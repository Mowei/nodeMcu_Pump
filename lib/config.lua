local moduleName = ...
local M = {}
_G[moduleName] = M

M.SSID = {}  
M.SSID["WIFI"] = "AAA"
M.SSID["WIFI2"] = "BBB"
M.SSID["WIFI3"] = "CCC"

M.BROKER = "m.cloudmqtt.com"
--M.BROKER = "broker.hivemq.com"
M.UN = "FISH_" .. node.chipid()
M.PS = node.chipid()
M.RECONNECT = 0
M.QOS = 0
M.PORT = 1883
M.KEEPALIVE = 120
M.ID = node.chipid()
--M.RETAIN = 0

--Config
M.MyEspName = "FISH_" .. node.chipid()
M.MyTopic = "TEST/MyTopic"
--M.RainUrl = "http://z88206.lionfree.net/fishfarm/FishMcu.php"
M.RainSchedule = "40 * * * *"
M.ScheduleStatus = "Auto" --Auto and Lock

M.Schedule={}
M.Schedule[0] = "30 19 * * *"
M.Schedule[1] = "30 6 * * *"
M.Schedule[2] = "30 17 * * *"
M.RestartSchedule = "0 8 * * 4"

mydata = require("mydata")
local flag ,pumpon = mydata.read_setting("PUMPON")
if flag == true then
    M.Schedule[0] = pumpon
end

local flag ,pumpoff = mydata.read_setting("PUMPOFF")
if flag == true then
    M.Schedule[1] = pumpoff
end

local flag ,reboottime = mydata.read_setting("REBOOTTIME")
if flag == true then
    M.RestartSchedule = reboottime
end

mydata =nil
package.loaded ['mydata'] = nil
                
M.PumpPin={}
M.PumpPin[0]=5
M.PumpPin[1]=6
M.PumpPin[2]=7
M.PumpPin[3]=8

return M 
