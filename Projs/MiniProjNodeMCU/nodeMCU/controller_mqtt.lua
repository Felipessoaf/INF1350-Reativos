--Nome: Felipe Pessoa e Guilherme Bizzo
--Matricula: 1411716 e 1710563

--leds
local led1 = 0
local led2 = 6

--switches
local sw1 = 3
local sw2 = 4
local sw3 = 5
local sw4 = 8

-- Buzzer
local buzzer=7

local meuid = "abacateverde"
local m = mqtt.Client("clientid " .. meuid, 120)

--leds
gpio.mode(led1, gpio.OUTPUT)
gpio.mode(led2, gpio.OUTPUT)

gpio.write(led1, gpio.HIGH);
gpio.write(led2, gpio.HIGH);

--switches
gpio.mode(sw1,gpio.INT,gpio.PULLUP)
gpio.mode(sw2,gpio.INT,gpio.PULLUP)
gpio.mode(sw3,gpio.INT,gpio.PULLUP)
gpio.mode(sw4,gpio.INT,gpio.PULLUP)

local function beep(freq, duration)
    pwm.stop(buzzer)
    pwm.setup(buzzer, freq, 512)
    pwm.start(buzzer)
    tmr.create():alarm(duration, tmr.ALARM_SINGLE, function() pwm.stop(buzzer) end)
end

function criaPublica(c,m)
    return function()
        publica(c,m)
    end
end

function publica(c, m)
    c:publish("paraloveFG",m,0,0, 
            function(client)  end)
end

function novaInscricao (c)
  local msgsrec = 0
  local aceso1 = true
  local aceso2 = true

  local function novamsg (c, t, m)
    print ("mensagem ".. msgsrec .. ", topico: ".. t .. ", dados: " .. m)
    msgsrec = msgsrec + 1
    
    if m == "jump" then
        beep(500, 100)
    end
  end
  c:on("message", novamsg)
end

function conectado (newclient)
    client = newclient
    client:subscribe("paranodeFG", 0, novaInscricao)

    gpio.trig(sw1, "down", criaPublica(client, "btn1"))
    gpio.trig(sw2, "down", criaPublica(client, "btn2"))
    gpio.trig(sw3, "down", criaPublica(client, "btn3"))
    gpio.trig(sw4, "down", criaPublica(client, "btn4"))
end 

m:connect("broker.hivemq.com", 1883, false, 
             conectado,
             function(client, reason) print("failed reason: "..reason) end)