#!/opt/local/bin/lua

local mmdvm = require("mmdvm")

--json = require("cjson")
parser = require("log_parser")

------------------------------------
-- reverse the table(array) order 
------------------------------------
function reverse_table( tbl )
	local len = #tbl
	local ret = {}
	for i = len, 1, -1 do
		ret[ len - i + 1 ] = tbl[ i ]
	end
	return ret
end

------------------------------------
-- count table items
------------------------------------
function count_table (T)
    if T ~= nil then
        local count = 0
        for _ in pairs(T) do count = count + 1 end
        return count
    end
    return 0
end

---------------------------------------------
-- Reads logs from file by offset and limits
-- @param fileName
-- @param offset reads start offset, default 0
-- @param limit reads lines limited to 
---------------------------------------------
MAX_LINES_TO_READ = 1024
function read_log (fileName, offset, limit)
    if fileName == nil then return end
    if offset == nil then offset = 0 end
    if limit == nil then limit = MAX_LINES_TO_READ end

    -- count lines
    local r = io.popen(string.format("[ -f %s ] && cat %s | /usr/bin/wc -l",fileName,fileName))
    if r == nil then return end  -- count lines error
    local nofl = r:read("*n")
    r:close()
    if nofl == nil then 
        print(string.format("> file %s not found or empty",fileName))
        return
    else
        print(string.format("> Total %d lines found in file %s",nofl,fileName))
    end

    -- read last effective n lines
    local linesToRead = nofl - offset
    if linesToRead < 1 then return end -- nothing to read from the offset
    if linesToRead > limit then -- limits to max lines to read
        offset = nofl - limit
    end
    offset = offset + 1 -- the next line to start read
    -- sed offset,nofl lines 
    print(string.format("> Reads last %d lines, [%d,%d]",nofl - offset + 1, offset,nofl))
    r = io.popen(string.format("sed -ne \"%d,%dp\" %s",offset,nofl,fileName))
    if r == nil then return end -- tail file error
    local info,nol = parser.parse(r:lines())
    local nofr = count_table(info.rfActs) + count_table(info.netActs)
    print(string.format("> %d lines parsed, %d records found",nol, nofr))

    -- print the last heard sites
    print("")
    print("-= Last heard from RF =-")
    print_last_heard(info.rfActs,true)
    print("")
    print("-= Last heard from NET =-")
    print_last_heard(info.netActs,true)

    -- clean up
    r:close()
end

function print_last_heard ( acts , checkdup)
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

    for i = 1,#heard do
        local v = heard[i]
        if v.type == 'RF' then
            if v.duration then
                print(string.format("%s %s [%s] %s -> %s, dur: %s seconds, ber: %s",v.date,v.time,v.mode,v.from,v.to,v.duration,v.ber))
            else
                print(string.format("%s %s [%s] %s -> %s, TXing ...",v.date,v.time,v.mode,v.from,v.to))
            end    
        else
            if v.duration then
                print(string.format("%s %s [%s] %s -> %s at %s, dur: %s seconds, ber: %s",v.date,v.time,v.mode,v.from,v.to,v.via,v.duration,v.ber))
            else
                print(string.format("%s %s [%s] %s -> %s at %s, TXing ...",v.date,v.time,v.mode,v.from,v.to,v.via))
            end    
        end
    end
end

-- read_log(file,offset,limit)
read_log(arg[1], arg[2], arg[3])