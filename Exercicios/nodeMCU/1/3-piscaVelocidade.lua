local led1 = 0
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
        mytimer:unregister()
        tempo = tempo/2
        if tempo < 50 then
            tempo = 50
        end
        mytimer:register(tempo, tmr.ALARM_AUTO, piscapisca)
    end,
    function ()
        mytimer:unregister()
        tempo = tempo*2
        if tempo > 2000 then
            tempo = 2000
        end
        mytimer:register(tempo, tmr.ALARM_AUTO, piscapisca)
    end

end

local diminuiTempo,aumentaTempo = disparapiscapisca (led1, 500)
gpio.trig(sw1, "down", diminuiTempo)
gpio.trig(sw2, "down", aumentaTempo)
