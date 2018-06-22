-- Copyright 2018 BG5HHP (bg5hhp@hamclub.net)
-- Licensed to the GPL v3 for non-commercial use only 
-- the log parser module
log_parser = {}

local utils = require("mmdvm/utils")
local log = utils.log
local table  = require "table"
local string = require "string"

----------------------------------
-- split a line
----------------------------------
local function split_log_line (line)
    local words = {}
    for word in line:gmatch("[^,^%s]+") do  -- split the line into words separated by "," and " "
        table.insert(words, word) 
        --print(word)
    end
    if #words > 0 then
        return words
    else
        return nil
    end
end

----------------------------------
-- parse app info from log entry
----------------------------------
local function parse_app_info (line,words,info)
    if words == nil or #words < 4 then return nil end
    if info == nil then return nil end    
    if #words == 6 and words[5] == 'is' and words[6] == 'starting' then
        info.appName = words[4]
    elseif #words == 10 and words[4] == 'Built' then
        info.appBuild = string.format("%s %s %s %s %s %s",words[5],words[6],words[7],words[8],words[9],words[10])
    else
        return nil
    end
    info.type = 'APP'
    return info
end


-- local function parse_app_config (words)
-- end

-----------------------------------------------
-- parse NETWORK activitities from log
-- @returns 
--     start:{type,mode,from,to,gw,date,time}
--     stop: {type,mode,duration,loss,ber,date,time}
-----------------------------------------------
local function parse_net_activities (line,words,acts)
    if words == nil or #words < 4 then return nil end
    local _wcount = #words
    local info = nil

    -- M: 2018-05-14 01:32:28.471 DMR Slot 2, received network voice header from BG5HHP to TG 460501
    if _wcount == 15 and words[7] == 'received' and words[8] == 'network' and words[11] == 'from' then
        -- DMR NET START
        info = {}
        info.type = 'NET'
        info.mode = string.format("%s %s %s",words[4],words[5],words[6])
        info.from = words[12]
        info.to = words[14]..words[15]
        info.date = words[2]
        info.time = words[3]
        -- print(string.format("[%s] NET TX started, %s -> %s via %s",recv.mode,recv.from,recv.to,recv.via))
        if acts ~= nil then
            table.insert(acts,info)
        end

    -- M: 2018-05-14 01:32:28.845 DMR Slot 2, received network end of voice transmission, 0.5 seconds, 0% packet loss, BER: 0.0%
    elseif _wcount == 19 and words[7] == 'received' and words[8] == 'network' and words[9] == 'end' then
        -- DMR NET STOP
        info = acts[#acts]
        local _mode = string.format("%s %s %s",words[4],words[5],words[6])
        if info ~= nil and info.mode == _mode then
            info.duration = words[13]
            info.loss = words[15]
            if _wcount == 19 then
                info.ber = words[19]
            end
        else
            log("error parsing net-end dur/loss/der log, the net-start info is missing")
            log(">"..line)
        end

    -- M: 2018-05-14 04:14:19.082 DMR Slot 2, network watchdog has expired, 2.7 seconds, 53% packet loss, BER: 0.1%
    elseif _wcount == 17 and words[4] == 'DMR' and words[7] == 'network' and words[10] == 'expired' then
        -- DMR NET STOP
        info = acts[#acts]
        local _mode = string.format("%s %s %s",words[4],words[5],words[6])
        if info ~= nil and info.mode == _mode then
            info.duration = words[11]
            info.loss = words[13]
            if #words == 17 then
                info.ber = words[17]
            end
            -- print(string.format("[%s] NET TX stopped, duration: %s seconds, P-LOSS: %s, BER: %s",recv.mode,recv.duration, recv.loss,recv.ber))    
        else
            log("error parsing net-end dur/loss/der log, the net-start info is missing")
            log(">"..line)
        end


    -- M: 2018-04-30 11:27:26.830 YSF, received network data from   XXXX   to ALL        at BG5HHP
    elseif _wcount == 13 and words[5] == 'received' and words[6] == 'network' and words[7] == 'data' and words[8] == 'from' then
        -- YSF NET START
        info = {}
        info.type = 'NET'
        info.mode = words[4]
        info.from = words[9]
        info.to = words[11]
        info.via = words[13]
        info.date = words[2]
        info.time = words[3]
        -- print(string.format("[%s] NET TX started, %s -> %s via %s",recv.mode,recv.from,recv.to,recv.via))
        if acts ~= nil then
            table.insert(acts,info)
        end
    -- M: 2018-05-11 08:54:08.732 P25, received network transmission from BD3BAY to TG 10402
    elseif _wcount == 12 and words[5] == 'received' and words[6] == 'network' and words[7] == 'transmission' and words[8] == 'from' and words[11] == 'TG' then
        -- P25 NET START
        info = {}
        info.type = 'NET'
        info.mode = words[4]
        info.from = words[9]
        info.to = words[11]..words[12]
        info.date = words[2]
        info.time = words[3]
        if acts ~= nil then
            table.insert(acts,info)
        end
    -- M: 2018-04-30 11:27:27.115 YSF, received network end of transmission, 0.4 seconds, 0% packet loss, BER: 0.0%
    elseif _wcount == 16 and words[5] == 'received' and words[6] == 'network' and words[7] == 'end' then
        -- YSF NET STOP
        info = acts[#acts]
        if info ~= nil and info.mode == words[4] then
            info.duration = words[10]
            info.loss = words[12]
            info.ber = words[16]
            -- print(string.format("[%s] NET TX stopped, duration: %s seconds, P-LOSS: %s, BER: %s",recv.mode,recv.duration, recv.loss,recv.ber))    
        else
            log("error parsing net-end dur/loss/der log, the net-start info is missing")
            log(">"..line)
        end
    -- M: 2018-04-30 12:12:20.930 YSF, network watchdog has expired, 18.2 seconds, 0% packet loss, BER: 0.0%
    elseif _wcount >=13 and words[5] == 'network' and words[6] == 'watchdog' and words[8] == 'expired' then
        -- YSF NET STOP 2
        info = acts[#acts]
        if info ~= nil and info.mode == words[4] then
            info.duration = words[9]
            info.loss = words[11]
            if #words == 15 then
                info.ber = words[15]
            end
        else
            log("error parsing net-end dur/loss/der log, the net-start info is missing")
            log(">"..line)
        end
    
    -- M: 2018-05-11 08:54:20.436 P25, network end of transmission, 12.1 seconds, 1% packet loss, BER: 0.0%
    elseif _wcount >= 13 and words[5] == 'network' and words[6] == 'end' and words[8] == 'transmission' then
        -- P25 NET STOP
        info = acts[#acts]
        if info ~= nil and info.mode == words[4] then
            info.duration = words[9]
            info.loss = words[11]
            if #words == 15 then
                info.ber = words[15]
            end
            -- print(string.format("[%s] NET TX stopped, duration: %s seconds, P-LOSS: %s, BER: %s",recv.mode,recv.duration, recv.loss,recv.ber))    
        else
            log("error parsing net-end dur/loss/der log, the net-start info is missing")
            log(">"..line)
        end

    end
    return info
end

---------------------------------------------------
-- parse RF activitities from log and add to acts
-- @returns 
--     start:{type,mode,from,to,date,time}
--     stop: {type,mode,duration,ber,date,time}
---------------------------------------------------
local function parse_rf_activities (line, words, acts)
    if words == nil then return nil end
    local _wcount = #words
    if _wcount < 4 then return nil end

    local info = nil
    -- M: 2018-05-14 02:19:47.335 DMR Slot 1, received RF voice header from BG5HHP to TG 1
    if _wcount == 15 and words[4] == 'DMR' and words[5] == 'Slot' and words[7] == 'received' and words[8] == 'RF' and words[11] == 'from' then
        -- DMR RF start
        info = {}
        info.type = 'RF'
        info.mode = string.format("%s %s %s",words[4],words[5],words[6])
        info.from = words[12]
        info.to = words[14]..words[15]
        info.date = words[2]
        info.time = words[3]
        if acts ~= nil then
            table.insert(acts,info)
        end        
    -- M: 2018-04-30 11:11:44.383 YSF, received RF header from BG5HHP-2DR to ALL
    elseif _wcount == 11 and words[5] == 'received' and words[6] == 'RF' --[[and words[7] == 'header']] and words[8] == 'from' then
        -- YSF RF start
        info = {}
        info.type = 'RF'
        info.mode = words[4]
        info.from = words[9]
        info.to = words[11]
        info.date = words[2]
        info.time = words[3]
        if acts ~= nil then
            table.insert(acts,info)
        end
        -- print(string.format("[%s] RF TX started, %s -> %s",recv.mode,recv.from,recv.to))
    -- M: 2018-05-11 15:06:58.055 YSF, received RF late entry from BG5HHP-2DR to ALL
    elseif _wcount == 12 and words[5] == 'received' and words[6] == 'RF' and words[9] == 'from' then
        -- YSF RF start 2
        info = {}
        info.type = 'RF'
        info.mode = words[4]
        info.from = words[10]
        info.to = words[12]
        info.date = words[2]
        info.time = words[3]
        if acts ~= nil then
            table.insert(acts,info)
        end

    -- M: 2017-04-18 08:00:41.977 P25, received RF transmission from MW0MWZ to TG 10200
    elseif _wcount == 12 and words[5] == 'received' and words[6] == 'RF' --[[and words[7] == 'header']] and words[8] == 'from' then
        -- P25 RF start
        info = {}
        info.type = 'RF'
        info.mode = words[4]
        info.from = words[9]
        info.to = words[11]..words[12]
        info.date = words[2]
        info.time = words[3]
        if acts ~= nil then
            table.insert(acts,info)
        end
    
    -- M: 2018-05-14 02:19:47.757 DMR Slot 1, received RF end of voice transmission, 0.4 seconds, BER: 3.2%
    elseif _wcount >= 14 and words[4] == 'DMR' and words[5] == 'Slot' and words[7] == 'received' and words[8] == 'RF' and words[9] == 'end' then
        -- RF end
        info = acts[#acts] -- reuse the previous info with callsign->taget info
        local _mode = string.format("%s %s %s",words[4],words[5],words[6])
        if info ~= nil and info.mode == _mode then -- mode matches
            -- update the dur/ber/rssi            
            info.duration = words[13]
            if _wcount == 16 then 
                info.ber=words[16]
            end
        elseif info == nil then
            log("error parsing tx ber/der log, the tx-start info is missing")
            log(">"..line)
        end
    
    -- M: 2018-05-13 23:59:41.022 DMR Slot 2, RF voice transmission lost, 0.7 seconds, BER: 12.0%
    elseif _wcount >= 12 and words[4] == 'DMR' and words[5] == 'Slot' and words[7] == 'RF' and words[9] == 'transmission' and words[10] == 'lost' then
        -- RF lost
        info = acts[#acts] -- reuse the previous info with callsign->taget info
        local _mode = string.format("%s %s %s",words[4],words[5],words[6])
        if info ~= nil and info.mode == _mode then -- mode matches
            -- update the dur/ber/rssi            
            info.duration = words[11]
            if _wcount == 14 then 
                info.ber=words[14]
            end
        elseif info == nil then
            log("error parsing tx ber/der log, the tx-start info is missing")
            log(">"..line)
        end

    -- M: 2018-04-30 11:11:44.682 YSF, received RF end of transmission, 0.4 seconds, BER: 0.4%
    elseif _wcount >= 11 and words[5] == 'received' and words[6] == 'RF' and words[7] == 'end' then
        -- RF end
        info = acts[#acts] -- reuse the previous info with callsign->taget info
        if info ~= nil and info.mode == words[4] then -- mode matches
            -- update the dur/ber/rssi            
            info.duration = words[10]
            if #words == 13 then 
                info.ber=words[13]
            end
        elseif info == nil then
            log("error parsing tx ber/der log, the tx-start info is missing")
            log(">"..line)
        end
        -- print(string.format("[%s] RF TX stopped, duration: %s seconds",recv.mode,recv.duration))
    end

    return info
end

------------------------------------
-- parse log entries and 
-- @returns info table number of lines
------------------------------------
function log_parser.parse (lines)
    local appInfo , rfActs , netActs = {}, {}, {}
    local nofl = 0
    for line in lines do
        -- if line == "exit" then break end
        -- io.write('> ',line,'\n')
        local words = split_log_line(line)
        local r = parse_app_info(line,words,appInfo)     -- parse app info
        if r == nil then
            r = parse_rf_activities(line,words,rfActs)   -- parse rf activities
        end
        if r == nil then
            r = parse_net_activities(line,words,netActs) -- parse net activities
        end
        nofl = nofl + 1
    end

    local info = {}
    info.appInfo = appInfo
    info.rfActs = rfActs
    info.netActs = netActs
    --print(json.encode(info))
    return info,nofl
end

return log_parser
