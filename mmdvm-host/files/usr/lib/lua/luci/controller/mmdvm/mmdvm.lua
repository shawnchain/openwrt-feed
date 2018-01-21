module("luci.controller.mmdvm.mmdvm", package.seeall)

function index()
        if not nixio.fs.access("/etc/config/mmdvm") then
                return
        end

        local _mod
        entry({"admin", "mmdvm"}, firstchild(), "MMDVM", 60).dependent=false
        _mod = entry({"admin", "mmdvm", "log"}, call("mmdvm_log_action"), _("MMDVM Log") , 1)
        _mod.sysauth = "root"
        _mod.sysauth_authenticator = "htmlauth"

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
        luci.http.prepare_content("text/plain")
        luci.http.write("-= MMDVMHost Log =-")
        luci.http.write("\n...")
        for aline in luci.util.execi("_log=/var/log/MMDVM-`date -I`.log;[ -f $_log ] && tail -n 50 $_log || echo \"No log file $_log\"") do
                luci.http.write("\n" .. aline)
        end
end

function ysfgw_log_action()
        luci.http.prepare_content("text/plain")
        luci.http.write("-= YSF Gateway Log =-")
        luci.http.write("\n...")
        for aline in luci.util.execi("_log=/var/log/YSFGateway-`date -I`.log;[ -f $_log ] && tail -n 50 $_log || echo \"No log file $_log\"") do
                luci.http.write("\n" .. aline)
        end
end

function ysfrl_log_action()
        luci.http.prepare_content("text/plain")
        luci.http.write("-= YSF Reflector Log =-")
        luci.http.write("\n...")
        for aline in luci.util.execi("_log=/var/log/YSFReflector-`date -I`.log;[ -f $_log ] && tail -n 50 $_log || echo \"No log file $_log\"") do
                luci.http.write("\n" .. aline)
        end
end

function p25gw_log_action()
        luci.http.prepare_content("text/plain")
        luci.http.write("-= P25 Gateway Log =-")
        luci.http.write("\n...")
        for aline in luci.util.execi("_log=/var/log/P25Gateway-`date -I`.log;[ -f $_log ] && tail -n 50 $_log || echo \"No log file $_log\"") do
                luci.http.write("\n" .. aline)
        end
end

function p25rl_log_action()
        luci.http.prepare_content("text/plain")
        luci.http.write("-= P25 Reflector Log =-")
        luci.http.write("\n...")
        for aline in luci.util.execi("_log=/var/log/P25Reflector-`date -I`.log;[ -f $_log ] && tail -n 50 $_log || echo \"No log file $_log\"") do
                luci.http.write("\n" .. aline)
        end
end
