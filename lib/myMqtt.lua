local moduleName = ...
local M = {}
_G[moduleName] = M

M.status = "OFF"

function M.sendMsg(msg)
    if M.status == "ON" then
        m:publish(config.MyTopic, msg, 0,0, function(client) end)
    end
end

local function mqtt_start()  
   -- Connect to broker
    m:connect(config.BROKER, config.PORT, config.QOS, config.RECONNECT, function(client) 
    print("Connected!")
    print("Subscribing...")
    client:publish(config.MyTopic, config.MyEspName .. " HELLO!", 0, 0, function(client) print("connected") end)
        client:subscribe(config.MyTopic, 0, function(client) 
            M.status="ON"
            print("subscribe success") 
            print("Heap : " .. node.heap()) 
        end)
    end,
    function(client, reason)
        print("failed reason: " .. reason)
        setup.start()
    end)
    -- on publish message receive event
    m:on("message", function(client, topic, data) 
      print(topic .. ":" ) 
      if data ~= nil then
        data=string.upper(data)
        print(data)
        i,j,k = string.match(data,'(%S+) (%S+) (%S+)')
        if data=="GETTIME" then
          tm = rtctime.epoch2cal(rtctime.get())
          M.sendMsg(config.MyEspName .. string.format(" : %04d/%02d/%02d %02d:%02d:%02d\n", tm["year"], tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"]))
        end
        if data=="WHOAMI" then
          client:publish(config.MyTopic, config.MyEspName, 0, 0, function(client) print("sent") end)
        end
        if i==tostring(node.chipid()) then
            mytype,mynumber=string.match(j,'(%S+)(%d+)')
            if j =="TELNET" and k=="ON" then
                myStatus = "TELNET ON " .. wifi.sta.getip()
                dofile("telnet.lua")
            elseif j=="DOFILE" then
                dofile(k)            
            elseif j=="SET" then
                setname,setvalue = string.match(k,'(%S+)@@(%S+)')
                print(setname,setvalue)
                mydata = require("mydata")
                mydata.save_setting(setname,string.lower(setvalue))        
                mydata =nil
                package.loaded ['mydata'] = nil
                myStatus = "SET " .. setname .. " " .. setvalue
            elseif j=="SYSTEM" and k=="RESTART" then
                node.restart()
            elseif mytype=="PIN" then
                mydata = require("mydata")
                if k=="ON" then
                    mydata.set_pin(mynumber,gpio.HIGH)
                elseif k=="OFF" then
                    mydata.set_pin(mynumber,gpio.LOW)
                end
                mydata =nil
                package.loaded ['mydata'] = nil
                myStatus = "PIN" .. mynumber .. " " .. k .. " " ..  gpio.read(mynumber)
            end
            client:publish(config.MyTopic, myStatus .. " OK", 0, 0, function(client) print("sent") end)
        end
      end
    end)

   -- This is part when wifi disconnects and I tested it for 5 minutes connecting wifi back and this works
    m:on("offline", function(client) 
      print ("Offline " .. config.ID) 
      setup.start()
    end)
    
    print("Connecting to broker...")
end

function M.start()
  print("Starting MQTT module...")
  -- initiate the mqtt client and set keepalive timer to 120sec
  m = mqtt.Client(config.ID, config.KEEPALIVE,  config.UN, config.PS)
  --m = mqtt.Client(config.ID, config.KEEPALIVE)
  m:lwt(config.MyTopic, "lwt : Offline " .. config.ID, 0, 0)
  mqtt_start()
end


return M
