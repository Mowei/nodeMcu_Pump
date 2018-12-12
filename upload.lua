http.get("http://w6.loxa.edu.tw/sb8810/nodemcu/upload.lua", nil, function(code, data)
    if (code < 0) then
    else
        file.open("test", 'w')
        file.writeline(data)
        file.close()
    end
  end)