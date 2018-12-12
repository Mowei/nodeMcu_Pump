file.open("hello_world.txt")
while true 
do 
 line = file.readline() 
 if (line == nil) then 
 file.close()
 break 
 end
 print(line)
end