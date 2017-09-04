-- berberapa bagian saya adaptasi dari rtctime.c
-- dikoding oleh: hendra soewarno (0119067305)

local moduleName = ...
local M = {}
_G[moduleName] = M

--day per month/jumlah hari perbulan?
local dpm = {
    0,
    (31),
    (31+28),
    (31+28+31),
    (31+28+31+30),
    (31+28+31+30+31),
    (31+28+31+30+31+30),
    (31+28+31+30+31+30+31),
    (31+28+31+30+31+30+31+31),
    (31+28+31+30+31+30+31+31+30),
    (31+28+31+30+31+30+31+31+30+31),
    (31+28+31+30+31+30+31+31+30+31+30),
    (31+28+31+30+31+30+31+31+30+31+30+31)
}

function mod(a, b)
    return a - (math.floor(a/b))*b
end

function isleap (year)
    -- every fourth year is a leap year except for century years that are
    -- not divisible by 400. 
  return (mod(year,4)==0 and (mod(year,100)~=0 or mod(year,400)==0))
end

function M.cal2epoch(yyyy, mo, dd, hh, mm, ss)
    days = 0
    for year = 1970, yyyy-1 do
        if isleap(year) then
            days = days + 366
        else
            days = days + 365
        end
    end
    days = days + dpm[mo]
    if isleap(yyyy) and mo > 2 then days = days + 1 end
    days = days + dd - 1

    seconds = days*24*60*60 + hh*60*60+  mm*60 + ss

    return seconds
end

return M
