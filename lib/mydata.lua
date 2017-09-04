local moduleName = ...
local M = {}
_G[moduleName] = M

function M.set_pin(number, value)
  gpio.mode(number,gpio.OUTPUT)
  gpio.write(number,value)
  M.save_setting("PIN" .. number, value)
end


function M.read_pin(number)
  flag,value = M.read_setting("PIN" .. number)
  if flag == true then
      gpio.mode(number,gpio.OUTPUT)
      gpio.write(number,value)
  end
  return flag,value
end

function M.save_setting(name, value)
  value = string.gsub(value,"!!"," ")
  file.open(name, 'w') -- you don't need to do file.remove if you use the 'w' method of writing
  file.writeline(value)
  file.close()
end

function M.read_setting(name)
  if (file.open(name)~=nil) then
      result = string.sub(file.readline(), 1, -2) -- to remove newline character
      file.close()
      return true, result
  else
      return false, nil
  end
end

function M.raincheck()
    flag ,RainUrl = M.read_setting("RAINURL")
    if flag == false then
        RainUrl = config.RainUrl
    end
    http.get(RainUrl .. "?who=" .. config.ID, nil, function(code, data)
        if (code < 0) then
        print("HTTP request failed")
        app.sendMsg("RainUrl request failed")
        else
        local t= sjson.decode(data)
            for k,v in pairs(t) do 
                mypin,pin=string.match(k,'(%S+)(%d+)')
                if mypin=="pin" then
                    mydata = require("mydata")
                    mydata.set_pin(pin,v)
                    mydata =nil
                    package.loaded ['mydata'] = nil
                end
            end
        end
    end)
end

return M 
