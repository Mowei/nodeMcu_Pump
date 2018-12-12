function read_setting()
  if (file.open("my_setting.lua")~=nil) then
      result = file.read() -- to remove newline character
      file.close()
      return result
  else
      return false, nil
  end
end

function save_setting(name, value)
  file.remove("my_setting.lua");
  file.open("my_setting.lua", 'w+') -- you don't need to do file.remove if you use the 'w' method of writing


if name=="RU" then
    file.writeline("RainUrl = \"" .. value .. "\"")
else 
    file.writeline("RainUrl = \"" .. RainUrl .. "\"")
end

if name=="RS" then
  file.writeline("RainSchedule = \"" .. value .. "\"")
else 
    file.writeline("RainSchedule = \"" .. RainSchedule .. "\"")
end

if name=="SS" then
  file.writeline("ScheduleStatus = \"" .. value .. "\"")
else 
    file.writeline("ScheduleStatus = \"" .. ScheduleStatus .. "\"")
end

  file.writeline("Schedule= {}")
  
if name=="SS0" then
  file.writeline("Schedule[0] = \"" .. value .. "\"")
else 
    file.writeline("Schedule[0] = \"" .. Schedule[0] .. "\"")
end

if name=="SS1" then
  file.writeline("Schedule[1] = \"" .. value .. "\"")
else 
    file.writeline("Schedule[1] = \"" .. Schedule[1] .. "\"")
end

  file.close()
end
