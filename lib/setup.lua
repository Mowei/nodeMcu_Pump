local moduleName = ...
local M = {}
_G[moduleName] = M

local tmrTime = 0

local function wifi_wait_ip()  
  if wifi.sta.getip()== nil then
    print("IP unavailable, Waiting...")
    tmrTime = tmrTime + 1
    if tmrTime>=250 then
        tmrTime = 0
        M.start()
    end
  else
    tmrTime = 0
    tmr.stop(1)
    print("\n====================================")
    print("ESP8266 mode is: " .. wifi.getmode())
    print("MAC address is: " .. wifi.ap.getmac())
    print("IP is "..wifi.sta.getip())
    print("====================================")

    app.start()
  end
end

local function wifi_start(list_aps)  
    local find = false
    if list_aps then
        for key,value in pairs(list_aps) do
            if config.SSID and config.SSID[key] then
                wifi.setmode(wifi.STATION);
                wifi.sta.config(key,config.SSID[key])
                wifi.sta.connect()
                print("Connecting to " .. key .. " ...")
                --config.SSID = nil  -- can save memory
                tmr.alarm(1, 2500, 1, wifi_wait_ip)
                print("Connected!")
                find =true
            end
        end
        if find == false then
            dofile("enduser_setup.lua")
            tmr.alarm(1, 180000, 1, function()node.restart() end)
        end
    else
        print("Error getting AP list")
    end
end

function M.start()  
  app.status="OFF"
  print("Configuring Wifi ...")
  wifi.setmode(wifi.STATION);
  wifi.sta.getap(wifi_start)
end

return M 
