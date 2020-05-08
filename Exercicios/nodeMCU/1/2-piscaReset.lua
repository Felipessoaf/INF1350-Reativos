--Nome: Felipe Pessoa e Guilherme Bizzo
--Matricula: 1411716 e 1710563

local led1 = 0
local led2 = 6
local sw1 = 3
local sw2 = 4

gpio.mode(sw1,gpio.INT,gpio.PULLUP)
gpio.mode(sw2,gpio.INT,gpio.PULLUP)

local function disparapiscapisca (led, tempo)
    local apagado = true

    local function piscapisca(timer)
        if apagado then
        gpio.write(led, gpio.HIGH);
        else
        gpio.write(led, gpio.LOW);
        end
        apagado = not apagado
    end

    -- coloca o pino dos leds em modo de saida
    gpio.mode(led, gpio.OUTPUT)
    -- apaga o led
    gpio.write(led, gpio.LOW);
    
    local mytimer = tmr.create()
    mytimer:register(tempo, tmr.ALARM_AUTO, piscapisca)
    mytimer:start()

    return function ()
        print("piscaReset")
        if mytimer:state() then
            print("stop")
            mytimer:stop()
        else
            print("start")
            mytimer:start()
        end
    end
end

local piscaReset1 = disparapiscapisca (led1, 500)
gpio.trig(sw1, "down", piscaReset1)

local piscaReset2 = disparapiscapisca (led2, 750)
gpio.trig(sw2, "down", piscaReset2)
