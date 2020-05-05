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
local last = 0

local dbtmr
local tol = 50

local reestabelece, cbchave

local function trocaled ()
  last = timestamp
  ledstate =  not ledstate
  if ledstate then 
    gpio.write(led1, gpio.HIGH);
  else
    gpio.write(led1, gpio.LOW);
  end
end

function reestabelece ()
  gpio.trig(sw1, "down", cbchave)
end

function cbchave ()
  -- suspende tratamento de sinais da chave por um tempo
  gpio.trig(sw1)
  dbtmr:register(tol, tmr.ALARM_AUTO, reestabelece)
  dbtmr:start()
  -- trata chave
  trocaled()
end
  
dbtmr = tmr.create()
gpio.trig(sw1, "down", cbchave)


