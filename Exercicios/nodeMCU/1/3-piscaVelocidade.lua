--Nome: Felipe Pessoa e Guilherme Bizzo
--Matricula: 1411716 e 1710563

local led1 = 0
local sw1 = 3
local sw2 = 4

gpio.mode(sw1,gpio.INT,gpio.PULLUP)
gpio.mode(sw2,gpio.INT,gpio.PULLUP)

local function disparapiscapisca (led, tempo)
    local apagado = true
    local key1Pressed = false
    local key2Pressed = false
    local dbtmr = tmr.create()
    
    local mytimer = tmr.create()

    local function piscapisca(timer)
        if apagado then
            gpio.write(led, gpio.HIGH);
        else
            gpio.write(led, gpio.LOW);
        end
            apagado = not apagado
    end

    local function checkStopAll(key)
        if key then
            gpio.trig(sw1)
            gpio.trig(sw2)
            mytimer:unregister()
            gpio.write(led, gpio.LOW);
        end
    end
    
    mytimer:register(tempo, tmr.ALARM_AUTO, piscapisca)
    mytimer:start()

    -- coloca o pino dos leds em modo de saida
    gpio.mode(led, gpio.OUTPUT)
    -- apaga o led
    gpio.write(led, gpio.LOW);

    return function ()
        mytimer:unregister()
        tempo = tempo/2
        if tempo < 50 then
            tempo = 50
        end
        mytimer:register(tempo, tmr.ALARM_AUTO, piscapisca)
        mytimer:start()

        key1Pressed = true
        checkStopAll(key2Pressed)

        dbtmr:unregister()
        dbtmr:register(500, tmr.ALARM_SINGLE, function()
            key1Pressed = false
        end)
        dbtmr:start()        
    end,
    function ()
        mytimer:unregister()
        tempo = tempo*2
        if tempo > 2000 then
            tempo = 2000
        end
        mytimer:register(tempo, tmr.ALARM_AUTO, piscapisca)
        mytimer:start()

        key2Pressed = true
        checkStopAll(key1Pressed)

        dbtmr:unregister()
        dbtmr:register(500, tmr.ALARM_SINGLE, function()
            key2Pressed = false
        end)
        dbtmr:start()  
    end

end

local diminuiTempo,aumentaTempo = disparapiscapisca (led1, 500)
gpio.trig(sw1, "down", diminuiTempo)
gpio.trig(sw2, "down", aumentaTempo)
