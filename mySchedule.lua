--every day check time
cron.schedule("0 9 * * *", function(e)
    print("check ntp")
    sntp.sync("TIME.google.com",
      function(sec, usec, server, info)
        print('sync', sec, usec, server)
        sec, usec = rtctime.get()
        rtctime.set(sec+28800, usec)
        ds3231 = require("ds3231")
        ds3231.espRTCToDs3231()
        ds3231 =nil
        package.loaded ['ds3231'] = nil
      end,
      function()
        print('failed!')
        ds3231 = require("ds3231")
        ds3231.ds3231ToEspRTC()
        ds3231 =nil
        package.loaded ['ds3231'] = nil
      end
    )

end)
--reboot
cron.schedule(config.RestartSchedule, function(e)
    app.sendMsg("restart")
    node.restart()
end)
--rain check
--cron.schedule(config.RainSchedule, function(e)
--    mydata = require("mydata")      
--    mydata.raincheck() 
--    mydata =nil
--    package.loaded ['mydata'] = nil
--end)
--pump ON
cron.schedule(config.Schedule[0], function(e)
    mydata = require("mydata")      
    for i=0, 3 do
        mydata.set_pin(config.PumpPin[i],gpio.HIGH)
    end 
    mydata =nil
    package.loaded ['mydata'] = nil
    app.sendMsg("Pump All ON")
end)
--pump OFF
cron.schedule(config.Schedule[1], function(e)
    mydata = require("mydata")      
    for i=0, 3 do
        mydata.set_pin(config.PumpPin[i],gpio.LOW)
    end 
    mydata =nil
    package.loaded ['mydata'] = nil
    app.sendMsg("Pump All OFF")
end)
--pump OFF
cron.schedule(config.Schedule[2], function(e)
    mydata = require("mydata")      
    for i=0, 3 do
        mydata.set_pin(config.PumpPin[i],gpio.LOW)
    end 
    mydata =nil
    package.loaded ['mydata'] = nil
    app.sendMsg("Pump All OFF")
end)

