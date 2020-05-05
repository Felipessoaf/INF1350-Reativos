local led1 = 0
local led2 = 6

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
end

disparapiscapisca (led1, 500)
disparapiscapisca (led2, 750)
