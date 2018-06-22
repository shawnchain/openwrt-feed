utils = {}

------------------------------------
-- the log helpers
------------------------------------
local _log_on = true
function utils.log_on(x)
    if x == true then
        _log_on = true
    else
        _log_on = false
    end
end
function utils.log (x)
    if _log_on == false then return end
    local pp   = io.popen(string.format("logger -t mmdvm-luci \"%s\"",x))
	local data = pp:read("*a")
	pp:close()
	return data
end

------------------------------------
-- reverse the table(array) order 
------------------------------------
function utils.reverse_table( tbl )
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
function utils.count_table (T)
    if T ~= nil then
        local count = 0
        for _ in pairs(T) do count = count + 1 end
        return count
    end
    return 0
end


--
-- calculate the timezone_offset in seconds
--
local function tz_offset_seconds(tz)

	if type(tz) == "string" then

		-- check for a numeric identifier
		local s, v = tz:match("([%+%-])([0-9]+)")
		if s == '+' then s = 1 else s = -1 end
		if v then v = tonumber(v) end

		if s and v then
			return s * 60 * 60 * ( math.floor( v / 100 ) * 60 + ( v % 100 ) )

		-- lookup symbolic tz
		elseif luci.sys.zoneinfo.OFFSET[tz:lower()] then
			return 60 * luci.sys.zoneinfo.OFFSET[tz:lower()]
		end

	end

	-- bad luck
	return 0
end

--
-- convert string 1999-01-01 01:02:03.456 to 1526233239021(ms)
--
function utils.to_timestamp (s)
    if type(s) ~= "string" then return nil end
    local tz = "+8"
    local yr, mon, day, hr, min, sec, mil = s:match(
		"([0-9]+)-([0-9]+)-([0-9]+) " ..
		"([0-9]+):([0-9]+):([0-9]+).([0-9]+)"
    )
    if yr and mon and day and hr and min and sec and mil then
		-- convert to epoch time
		return (tz_offset_seconds(tz) + os.time( {
			year  = yr,
			month = mon,
			day   = day,
			hour  = hr,
			min   = min,
			sec   = sec
		} ) ) * 1000 + mil
	end

	return 0
end

return utils