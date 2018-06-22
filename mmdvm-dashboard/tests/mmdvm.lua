mmdvm = {}

local io     = require "io"
-- local os     = require "os"
local table  = require "table"
-- local nixio  = require "nixio"
-- local fs     = require "nixio.fs"
-- local uci    = require "luci.model.uci"

local parser = require "mmdvm/log_parser"
local utils = require "mmdvm/utils"
local log = utils.log
local reverse_table = utils.reverse_table
local count_table = utils.count_table

-- module "mmdvm"

---------------------------------------------
-- Reads logs from file by offset and limits
-- @param fileName
-- @param offset reads start offset, default 0
-- @param limit reads lines limited to 
---------------------------------------------
local MAX_LINES_TO_READ = 1024
local function read_log (fileName, offset, limit)
    if fileName == nil then return end
    if offset == nil then offset = 0 end
    if limit == nil then limit = MAX_LINES_TO_READ end

    -- count lines
    local r = io.popen(string.format("[ -f %s ] && cat %s | /usr/bin/wc -l",fileName,fileName))
    if r == nil then return end  -- count lines error
    local nofl = r:read("*n")
    r:close()
    if nofl == nil then 
        log(string.format("> file %s not found or empty",fileName))
        return
    else
        log(string.format("> Total %d lines found in file %s",nofl,fileName))
    end

    -- read last effective n lines
    local linesToRead = nofl - offset
    if linesToRead < 1 then return end -- nothing to read from the offset
    if linesToRead > limit then -- limits to max lines to read
        offset = nofl - limit
    end
    offset = offset + 1 -- the next line to start read
    -- sed offset,nofl lines 
    log(string.format("> Reads last %d lines, [%d,%d]",nofl - offset + 1, offset,nofl))
    r = io.popen(string.format("sed -ne \"%d,%dp\" %s",offset,nofl,fileName))
    if r == nil then return end -- tail file error
    local info,nol = parser.parse(r:lines())
    local nofr = count_table(info.rfActs) + count_table(info.netActs)
    log(string.format("> %d lines parsed, %d records found",nol, nofr))

    -- clean up
    r:close()

    return info
end

local function read_last_heard (acts , checkdup)
    local heard_dup_check = {}
    local heard = {}
    acts = reverse_table(acts) -- in desc order
    for i = 1,#acts do
        local act = acts[i]
        if act.from ~= nil and act then
            local k = act.mode.."#"..act.from
            if checkdup ~= true or heard_dup_check[k] == nil then
                table.insert(heard,act)
                if checkdup == true then
                    heard_dup_check[k] = act
                end
            end
        end
    end

    local output = {}
    for i = 1,#heard do
        local v = heard[i]
        local s = nil
        if v.type == 'RF' then
            if v.duration then
                s = string.format("%s %s [%s] %s -> %s, dur: %s seconds, ber: %s",v.date,v.time,v.mode,v.from,v.to,v.duration,v.ber)
            else
                s = string.format("%s %s [%s] %s -> %s, TXing ...",v.date,v.time,v.mode,v.from,v.to)
            end    
        else
            if v.duration then
                s = string.format("%s %s [%s] %s -> %s at %s, dur: %s seconds, ber: %s",v.date,v.time,v.mode,v.from,v.to,v.via,v.duration,v.ber)
            else
                s = string.format("%s %s [%s] %s -> %s at %s, TXing ...",v.date,v.time,v.mode,v.from,v.to,v.via)
            end    
        end
        if s ~= nil then
            --log(s)
            table.insert(output,s)
        end
    end
    return output
end

local MMDVM_LOG_DIR = "/var/log"
local MMDVM_LOG_NAME = "MMDVM.log"

function mmdvm.last_heard()
    --TODO calculate current date
    local info = read_log("/opt/mmdvm/logs/MMDVM.log")
    if info then
        local lh_rf = read_last_heard(info.rfActs,true)
        local lh_net = read_last_heard(info.netActs,true)
        return lh_rf,lh_net
    end
end

return mmdvm

