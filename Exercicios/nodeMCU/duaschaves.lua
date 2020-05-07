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
gpio.mode(sw2,gpio.INT,gpio.PULLUP)

function newpincb (led)
  local ledstate = false
  local delay = 500000
  local last = 0

  return function (level, timestamp)
    if timestamp - last < delay then return end
    last = timestamp
    ledstate =  not ledstate
    if ledstate then 
      gpio.write(led, gpio.HIGH);
    else
      gpio.write(led, gpio.LOW);
    end
  end
end


gpio.trig(sw1, "down", newpincb(led1))
gpio.trig(sw2, "down", newpincb(led2))
