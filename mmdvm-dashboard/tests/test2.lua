#!/opt/local/bin/lua

mmdvm = require("mmdvm")

local lh_rf, lh_net = mmdvm.last_heard()
if lh_rf and lh_net then
    print "-== Local RF Heard ==-"
    for i=1,#lh_rf do
        print(lh_rf[i])
    end
    print ""
    print "-== Network Heard ==-"
    for i=1,#lh_net do
        print(lh_net[i])
    end
else
    print("nothing heard")
end
