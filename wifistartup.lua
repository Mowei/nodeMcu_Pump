print(wifi.sta.getip())
wifi.setmode(wifi.STATION)
wifi.sta.config("WiFi","pass")
print(wifi.sta.getip())
