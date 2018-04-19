module("luci.controller.mmdvm.mmdvm", package.seeall)

function index()
        if not nixio.fs.access("/etc/config/mmdvm") then
                return
        end

        local _mod
        entry({"admin", "mmdvm"}, firstchild(), "MMDVM", 60).dependent=false
        _mod = entry({"admin", "mmdvm", "log"}, call("mmdvm_log_action"), _("MMDVM LOG") , 1)
        _mod.sysauth = "root"
        _mod.sysauth_authenticator = "htmlauth"

        _mod = entry({"admin", "mmdvm", "config"}, call("mmdvm_cfg_action"), _("MMDVM CFG") , 1)
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

function mmdvm_log_action()
        local logs = luci.util.exec("tail -n 100 /var/log/MMDVM-$(date -u +%Y-%m-%d).log")
        luci.template.render("mmdvm/mmdvmhostlog",{logs=logs})
end

function mmdvm_restart_action()
        luci.util.exec("/etc/init.d/mmdvmhost restart")
end

function mmdvm_cfg_action()
        local cfg = luci.util.exec("cat /etc/MMDVM.ini")
        luci.template.render("mmdvm/mmdvmhostcfg",{cfg=cfg})
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
