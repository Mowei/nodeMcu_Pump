sntp.sync("TIME.google.com",
  function(sec, usec, server, info)
    print('sync', sec, usec, server)
    sec, usec = rtctime.get()
    rtctime.set(sec+28800, usec)
    ds3231 = require("ds3231")
    ds3231.espRTCToDs3231()
    ds3231 = nil
    package.loaded["ds3231"]=nil
  end,
  function()
    print('failed!')
    ds3231 = require("ds3231")
    ds3231.ds3231ToEspRTC()
    ds3231 = nil
    package.loaded["ds3231"]=nil
  end
)
