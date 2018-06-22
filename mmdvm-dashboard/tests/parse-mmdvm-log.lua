#!/opt/local/bin/lua
--[[
M: 2018-04-30 11:09:32.389 MMDVMHost-BG5HHP-mod-20171115 is starting
M: 2018-04-30 11:09:32.389 Built 16:09:53 Apr 24 2018 (GitID #c2e8e85)
I: 2018-04-30 11:09:34.471 MMDVM protocol version: 1, description: MMDVM_HS ADF7021 v1.0.1 20170826 (DStar/DMR/YSF/P25) GitID #2beb3d7
M: 2018-04-30 11:09:34.499 MMDVMHost-BG5HHP-mod-20171115 is running

M: 2018-04-30 11:11:44.383 YSF, received RF header from BG5HHP-2DR to ALL
M: 2018-04-30 11:11:44.682 YSF, received RF end of transmission, 0.4 seconds

M: 2018-04-30 11:27:26.830 YSF, received network data from            to ALL        at BG5HHP
M: 2018-04-30 11:27:27.115 YSF, received network end of transmission, 0.4 seconds, 0% packet loss, BER: 0.0%


M: 2018-04-30 13:07:05.130 YSF, received RF end of transmission, 1.0 seconds, BER: 1.7%
]]

json = require("cjson")

function parse_log_entry (line)
    local words = {}
    for word in line:gmatch("[^,^%s]+") do  -- split the line
        table.insert(words, word) 
        --print(word)
    end
    
    if #words < 4 then return nil end -- bail out of line is invalid

    local info = {}
    info.date = words[2]
    info.time = words[3]

    -- version and build
    if #words == 6 and words[5] == 'is' and words[6] == 'starting' then
        info.appName = words[4]
        return info
    end
    if #words == 10 and words[4] == 'Built' then
        info.appBuild = string.format("%s %s %s %s %s %s",words[5],words[6],words[7],words[8],words[9],words[10])
        return info
    end

    -- receving part
    local recv = {}
    -- RF
    if #words == 11 and words[5] == 'received' and words[6] == 'RF' and words[7] == 'header' and words[8] == 'from' then
        -- RF start
        recv.type = 'RF'
        recv.mode = words[4]
        recv.from = words[9]
        recv.to = words[11]
        -- print(string.format("[%s] RF TX started, %s -> %s",recv.mode,recv.from,recv.to))
    elseif #words >= 11 and words[5] == 'received' and words[6] == 'RF' and words[7] == 'end' then
        -- RF end
        recv.type = 'RF'
        recv.mode = words[4]
        recv.elapsed = words[10]
	if #words == 13 then recv.ber=words[13] end
        -- print(string.format("[%s] RF TX stopped, elapsed %s seconds",recv.mode,recv.elapsed))

    -- Network logs
    elseif #words == 13 and words[5] == 'received' and words[6] == 'network' and words[7] == 'data' and words[8] == 'from' then
        recv.type = 'NET'
        recv.mode = words[4]
        recv.from = words[9]
        recv.to = words[11]
        recv.gw = words[13]
        -- print(string.format("[%s] NET TX started, %s -> %s via %s",recv.mode,recv.from,recv.to,recv.via))
    elseif #words == 16 and words[5] == 'received' and words[6] == 'network' and words[7] == 'end' then
        recv.type = 'NET'
        recv.mode = words[4]
        recv.elapsed = words[10]
        recv.ploss = words[12]
        recv.ber = words[16]
        -- print(string.format("[%s] NET TX stopped, elapsed %s seconds, P-LOSS: %s, BER: %s",recv.mode,recv.elapsed, recv.packetLoss,recv.bitErrorRate))
    end

    if next(recv) ~= nil then 
        info.recv=recv
    else
        info = nil
    end

    return info
end

function parse_log (lines)
    for line in lines do
        if line == "exit" then break end
        io.write('> ',line,'\n')
        local info = parse_log_entry(line)
        if info ~= nil then
            print(json.encode(info))
        end
    end
end


parse_log(io.lines())