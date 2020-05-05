local led1 = 0
local led2 = 6
local sw1 = 3
local sw2 = 4
local sw3 = 5
local sw4 = 8

gpio.mode(led1, gpio.OUTPUT)
gpio.mode(led2, gpio.OUTPUT)

gpio.write(led1, gpio.LOW);
gpio.write(led2, gpio.LOW);

gpio.mode(sw1,gpio.INT,gpio.PULLUP)

local ledstate = false
local delay = 500000
local last = 0

local function trocaled (level, timestamp)
  if timestamp - last < delay then return end
  last = timestamp
  ledstate =  not ledstate
  if ledstate then 
    gpio.write(led1, gpio.HIGH);
  else
    gpio.write(led1, gpio.LOW);
  end
end


gpio.trig(sw1, "down", trocaled)
