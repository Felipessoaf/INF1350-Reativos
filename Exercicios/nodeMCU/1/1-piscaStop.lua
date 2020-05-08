--Nome: Felipe Pessoa e Guilherme Bizzo
--Matricula: 1411716 e 1710563

local led1 = 0
local sw1 = 3

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

  return mytimer
end

function stopPisca()
    timer:stop()
end

timer = disparapiscapisca (led1, 500)
gpio.trig(sw1, "down", stopPisca)
