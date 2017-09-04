local moduleName = ...
local M = {}
_G[moduleName] = M

-- Default value for i2c communication
local id = 0

--device address
local dev_addr = 0x68

local function decToBcd(val)
  return((((val/10) - ((val/10)%1)) *16) + (val%10))
end

local function bcdToDec(val)
  return((((val/16) - ((val/16)%1)) *10) + (val%16))
end

-- initialize i2c
--parameters:
--d: sda
--l: scl
function M.init(d, l)
  if (d ~= nil) and (l ~= nil) and (d >= 0) and (d <= 11) and (l >= 0) and ( l <= 11) and (d ~= l) then
    sda = d
    scl = l
  else
    print("iic config failed!") return nil
  end
    print("init done")
    i2c.setup(id, sda, scl, i2c.SLOW)
end

--get time from DS3231
function M.getTime()
  i2c.start(id)
  i2c.address(id, dev_addr, i2c.TRANSMITTER)
  i2c.write(id, 0x00)
  i2c.stop(id)
  i2c.start(id)
  i2c.address(id, dev_addr, i2c.RECEIVER)
  local c=i2c.read(id, 7)
  i2c.stop(id)
  return bcdToDec(tonumber(string.byte(c, 1))),
  bcdToDec(tonumber(string.byte(c, 2))),
  bcdToDec(tonumber(string.byte(c, 3))),
  bcdToDec(tonumber(string.byte(c, 4))),
  bcdToDec(tonumber(string.byte(c, 5))),
  bcdToDec(tonumber(string.byte(c, 6))),
  bcdToDec(tonumber(string.byte(c, 7)))
end

--set time for DS3231
function M.setTime(second, minute, hour, day, date, month, year)
  i2c.start(id)
  i2c.address(id, dev_addr, i2c.TRANSMITTER)
  i2c.write(id, 0x00)
  i2c.write(id, decToBcd(second))
  i2c.write(id, decToBcd(minute))
  i2c.write(id, decToBcd(hour))
  i2c.write(id, decToBcd(day))
  i2c.write(id, decToBcd(date))
  i2c.write(id, decToBcd(month))
  i2c.write(id, decToBcd(year))
  i2c.stop(id)
end

function M.ds3231ToEspRTC()
  myrtclib = require("myrtclib")
  M.init(1,2)
  second, minute, hour, day, date, month, year = M.getTime()
  print(string.format("RTC Module DateTime: %04d/%02d/%02d %02d:%02d:%02d\n", year, month,date, hour, minute, second))

  unixtime = myrtclib.cal2epoch(year+2000, month, date, hour, minute, second)
  rtctime.set(unixtime,0)

  tm = rtctime.epoch2cal(rtctime.get())
  print(string.format("SET ESP DateTime: %04d/%02d/%02d %02d:%02d:%02d\n", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"]))

  myrtclib = nil
  package.loaded["myrtclib"]=nil
end

function M.espRTCToDs3231()
    M.init(1,2)
    tm = rtctime.epoch2cal(rtctime.get())
    print(string.format("ESP DateTime: %04d/%02d/%02d %02d:%02d:%02d\n", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"]))
    -- Zet datum en tijd op 20 Maart 2016 21:30
    M.setTime(tm["sec"],tm["min"],tm["hour"],00,tm["day"],tm["mon"], tm["year"]-2000);
    second, minute, hour, day, date, month, year = M.getTime();
    print(string.format("Set RTC Module DateTime: %04d/%02d/%02d %02d:%02d:%02d\n", year, month,date, hour, minute, second))
end

return M
