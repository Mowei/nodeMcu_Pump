function read_setting()
  if (file.open("my_setting.lua")~=nil) then
      result = file.read() -- to remove newline character
      file.close()
      return result
  else
      return false, nil
  end
end