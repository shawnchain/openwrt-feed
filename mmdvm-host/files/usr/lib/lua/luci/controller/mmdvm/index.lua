module("luci.controller.mmdvm.index", package.seeall)

local mmdvm = require("mmdvm")
local mmdvm_utils = require("mmdvm/utils")
function index()
        if not nixio.fs.access("/etc/config/mmdvm") then
                return
        end

        local _mod
        entry({"admin", "mmdvm"}, firstchild(), "MMDVM", 60).dependent=false

        _mod = entry({"admin", "mmdvm", "dashboard"}, call("mmdvm_dashboard_action"), _("Dashboard") , 1)
        _mod.sysauth = "root"
        _mod.sysauth_authenticator = "htmlauth"

        _mod = entry({"admin", "mmdvm", "config"}, call("mmdvm_cfg_action"), _("MMDVM CFG") , 1)
        entry({"admin", "mmdvm", "dashboard", "data"}, call("mmdvm_dashboard_data"))

        _mod = entry({"admin", "mmdvm", "log"}, call("mmdvm_log_action"), _("MMDVM Log") , 2)
        _mod.sysauth = "root"
        _mod.sysauth_authenticator = "htmlauth"

	entry({"admin", "mmdvm", "restart", "call"}, post("mmdvm_restart_action"))

        _mod = entry({"admin", "mmdvm", "ysfgwlog"}, call("ysfgw_log_action"), _("YSF Gateway Log"), 10)
        _mod.sysauth = "root"
        _mod.sysauth_authenticator = "htmlauth"

        _mod = entry({"admin", "mmdvm", "ysfrllog"}, call("ysfrl_log_action"), _("YSF Reflector Log"), 20)
        _mod.sysauth = "root"
        _mod.sysauth_authenticator = "htmlauth"

        _mod = entry({"admin", "mmdvm", "p25gwlog"}, call("p25gw_log_action"), _("P25 Gateway Log"), 30)
        _mod.sysauth = "root"
        _mod.sysauth_authenticator = "htmlauth"

        _mod = entry({"admin", "mmdvm", "p25rllog"}, call("p25rl_log_action"), _("P25 Reflector Log"), 40)
        _mod.sysauth = "root"
        _mod.sysauth_authenticator = "htmlauth"
end

function mmdvm_dashboard_data()
        local lh = mmdvm.last_heard()
        lh.offset = 0
        luci.http.prepare_content("application/json")
        luci.http.write_json(lh)
end

function mmdvm_dashboard_action()        
        -- luci.http.prepare_content("text/plain")
        -- luci.http.write("-= Local RF =-")
        -- for i=1,#lh_rf do
        --     luci.http.write("\n" .. lh_rf[i])
        -- end
        -- luci.http.write("\n")

        -- luci.http.write("-= Network =-")
        -- for i=1,#lh_net do
        --         luci.http.write("\n" .. lh_net[i])
        -- end    
        -- luci.http.write("\n")
        luci.template.render("mmdvm/dashboard")
end

function mmdvm_restart_action()
	luci.util.exec("echo restarted >>/var/log/MMDVM-$(date -u +%Y-%m-%d).log")	
end

function mmdvm_cfg_action()
        local cfg = luci.util.exec("cat /etc/MMDVM.ini")
        luci.template.render("mmdvm/cfg",{cfg=cfg})
end

function mmdvm_log_action()
        local logs = luci.util.exec("tail -n 100 /var/log/MMDVM-$(date -u +%Y-%m-%d).log")
        local lines = {}
        -- split the log into lines
        for line in logs:gmatch("[^\n]+") do
            table.insert(lines, line) 
        end
        -- in DESC order
        lines = mmdvm_utils.reverse_table(lines)
        local len = #lines
        if len > 0 then
            logs = lines[1]
            for i = 2, len do
                logs = logs .. "\n" .. lines[i]
            end
        end
        luci.template.render("mmdvm/log",{logs=logs})
end

function ysfgw_log_action()
        luci.http.prepare_content("text/plain")
        luci.http.write("-= YSF Gateway Log =-")
        luci.http.write("\n...")
        for aline in luci.util.execi("_log=/var/log/YSFGateway-$(date -u +%Y-%m-%d).log;[ -f $_log ] && tail -n 50 $_log || echo \"No log file $_log\"") do
                luci.http.write("\n" .. aline)
        end
end

function ysfrl_log_action()
        luci.http.prepare_content("text/plain")
        luci.http.write("-= YSF Reflector Log =-")
        luci.http.write("\n...")
        for aline in luci.util.execi("_log=/var/log/YSFReflector-$(date -u +%Y-%m-%d).log;[ -f $_log ] && tail -n 50 $_log || echo \"No log file $_log\"") do
                luci.http.write("\n" .. aline)
        end
end

function p25gw_log_action()
        luci.http.prepare_content("text/plain")
        luci.http.write("-= P25 Gateway Log =-")
        luci.http.write("\n...")
        for aline in luci.util.execi("_log=/var/log/P25Gateway-$(date -u +%Y-%m-%d).log;[ -f $_log ] && tail -n 50 $_log || echo \"No log file $_log\"") do
                luci.http.write("\n" .. aline)
        end
end

function p25rl_log_action()
        luci.http.prepare_content("text/plain")
        luci.http.write("-= P25 Reflector Log =-")
        luci.http.write("\n...")
        for aline in luci.util.execi("_log=/var/log/P25Reflector-$(date -u +%Y-%m-%d).log;[ -f $_log ] && tail -n 50 $_log || echo \"No log file $_log\"") do
                luci.http.write("\n" .. aline)
        end
end