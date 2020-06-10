--Nome: Felipe Pessoa e Guilherme Bizzo
--Matricula: 1411716 e 1710563

local led1 = 0
local led2 = 6
local sw1 = 3
local sw2 = 4

local meuid = "abacateverde"
local m = mqtt.Client("clientid " .. meuid, 120)

gpio.mode(led1, gpio.OUTPUT)
gpio.mode(led2, gpio.OUTPUT)

gpio.write(led1, gpio.HIGH);
gpio.write(led2, gpio.HIGH);

gpio.mode(sw1,gpio.INT,gpio.PULLUP)
gpio.mode(sw2,gpio.INT,gpio.PULLUP)

function criaPublica(c,m)
    return function()
        publica(c,m)
    end
end

function publica(c, m)
    c:publish("paraloveFG",m,0,0, 
            function(client) print("mandou!") end)
end

function novaInscricao (c)
  local msgsrec = 0
  local aceso1 = true
  local aceso2 = true

  local function novamsg (c, t, m)
    print ("mensagem ".. msgsrec .. ", topico: ".. t .. ", dados: " .. m)
    -- msgsrec = msgsrec + 1
    -- if m == "1" then
    --     if aceso1 then
    --       gpio.write(led1, gpio.LOW);
    --     else
    --       gpio.write(led1, gpio.HIGH);
    --     end
    --     aceso1 = not aceso1
    -- elseif m == "2" then
    --     if aceso2 then
    --       gpio.write(led2, gpio.LOW);
    --     else
    --       gpio.write(led2, gpio.HIGH);
    --     end
    --     aceso2 = not aceso2
    -- end
  end
  c:on("message", novamsg)
end

function conectado (newclient)
    client = newclient
    client:subscribe("paranodeFG", 0, novaInscricao)

    gpio.trig(sw1, "down", criaPublica(client, 1))
    gpio.trig(sw2, "down", criaPublica(client, 2))
end 

m:connect("broker.hivemq.com", 1883, false, 
             conectado,
             function(client, reason) print("failed reason: "..reason) end)