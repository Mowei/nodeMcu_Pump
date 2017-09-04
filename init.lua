print("\n")
print("ESP8266 Started \n")
config = require("config")

--set Time
ds3231 = require("ds3231")
ds3231.ds3231ToEspRTC()
ds3231 =nil
package.loaded ['ds3231'] = nil

--restore status
mydata = require("mydata")      
for i=0, 3 do
    mydata.read_pin(config.PumpPin[i])
end 
mydata =nil
package.loaded ['mydata'] = nil

--dothing
setup = require("setup")
app = require("myMqtt")
setup.start()
dofile("mySchedule.lua")
