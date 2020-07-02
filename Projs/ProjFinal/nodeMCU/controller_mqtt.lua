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

-- ADC A0
local ldr=0 

local meuid = "AbacateVerde"
local m = mqtt.Client("clientid " .. meuid, 120)

-- Server var
local blocked = false

--leds
gpio.mode(led1, gpio.OUTPUT)
gpio.mode(led2, gpio.OUTPUT)

gpio.write(led1, gpio.LOW);
gpio.write(led2, gpio.LOW);

--switches
gpio.mode(sw1,gpio.INT,gpio.PULLUP)
gpio.mode(sw2,gpio.INT,gpio.PULLUP)
gpio.mode(sw3,gpio.INT,gpio.PULLUP)
gpio.mode(sw4,gpio.INT,gpio.PULLUP)

-- timer luminosidade
local mytimer = tmr.create()
mytimer:register(1000, tmr.ALARM_AUTO, function()
    local lum = 100 - (adc.read(ldr)/10.24)
    publica(client, "lum:"..tostring(lum))
end)
mytimer:start()

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
    if (c == nil) then
        -- print("client nil")
        return 
    end

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

function sendButton(action)
    if not blocked then
        action()
    end
end

function conectado (newclient)
    print("conectado")
    
    client = newclient
    client:subscribe("paranodeFG", 0, novaInscricao)

    --callback botoes
    gpio.trig(sw1, "both", function (level)
        sendButton(function ()
            publica(client, level == 1 and "btn1_up" or "btn1_down")
        end)
    end)

    gpio.trig(sw2, "both", function (level)
        sendButton(function ()
            publica(client, level == 1 and "btn2_up" or "btn2_down")
        end)
    end)

    gpio.trig(sw3, "down", function ()
        sendButton(function ()
            publica(client, "btn3")
        end)
    end)

    gpio.trig(sw4, "down",  function ()
        sendButton(function ()
            publica(client, "btn4")
        end)
    end)
end 

-- m:connect("broker.hivemq.com", 1883, false, 
m:connect("192.168.1.106", 1883, false, 
            conectado,
            function(client, reason) 
                print("failed reason: "..reason) 
            end)

----------------------------------------------SERVER------------------------------------------------------
-- local meusleds = {led1, led2}

-- for _,ledi in ipairs (meusleds) do
--     gpio.mode(ledi, gpio.OUTPUT)
-- end

-- for _,ledi in ipairs (meusleds) do
--     gpio.write(ledi, gpio.LOW);
-- end

-- local estadopisca={}
-- estadopisca[false]="OFF"
-- estadopisca[true]="ON_"

-- local piscando = {}
-- for _,ledi in ipairs (meusleds) do piscando[ledi] = false end
-- local apagado = {}
-- for _,ledi in ipairs (meusleds) do apagado[ledi] = true end

-- local lastlum = 0

-- local function piscapisca (t)
--     for _,i in ipairs (meusleds) do
--         if piscando[i] then
--             if apagado[i] then
--                 gpio.write(i, gpio.HIGH);
--             else
--                 gpio.write(i, gpio.LOW);
--             end
--             apagado[i] = not apagado[i]
--         end
--     end
-- end

-- local function mudapisca (qualled, st)
--     return function () 
--         piscando[qualled] = st
--     end
-- end

local movs = {}


function readlum()
    lastlum = adc.read(ldr)
end

local actions = {
    LERLUM = readlum,
    -- LIGA1 = mudapisca(led1, true),
    -- DESLIGA1 = mudapisca(led1, false),
    -- LIGA2 = mudapisca(led2, true),
    -- DESLIGA2 = mudapisca(led2, false),
}


local srv = net.createServer(net.TCP)

local function receiver(sck, request)

    print("recebeu:\n" .. request)

    -- analisa pedido para encontrar valores enviados
    local _, _, method, path, vars = string.find(request, "([A-Z]+) ([^?]+)%?([^ ]+) HTTP");
    print("vars: " .. (vars or "nada"))

    -- se nao conseguiu casar, tenta sem variaveis
    if (method == nil) then
        _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
    end
    
    local _GET = {}
    
    if (vars ~= nil) then
        for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
            _GET[k] = v
        end
    end


    local action = actions[_GET.pin]
    if action then action() end

    local vals = {
        LUM = string.format("%2.1f", lastlum),
        -- STLED1 = estadopisca[piscando[led1]],
        -- STLED2 = estadopisca[piscando[led2]],
    }
  

    local buf = [[
    <html>
    <body>
    <h1><u>Projeto Final INF1350 - Felipe e Guilherme</u></h1>
    <h2>Gerenciador do controle</h2>
            <p>Luminosidade: $LUM <a href="?pin=LERLUM"><button><b>REFRESH</b></button></a>
    </body>
    </html>
    ]]

    
    -- <p>PISCA LED 1: $STLED1  <a href="?pin=LIGA1"><button><b>ON</b></button></a>
    -- <a href="?pin=DESLIGA1"><button><b>OFF</b></button></a></p>
    -- <p>PISCA LED 2: $STLED2  <a href="?pin=LIGA2"><button><b>ON</b></button></a>
    -- <a href="?pin=DESLIGA2"><button><b>OFF</b></button></a></p>


    buf = string.gsub(buf, "$(%w+)", vals)
    sck:send(buf, 
            function()  -- callback: fecha o socket qdo acabar de enviar resposta
                print("respondeu") 
                sck:close() 
            end)

end

if srv then
    srv:listen(80, function(conn)
            print("\n\n===\ncliente conectado")
            conn:on("receive", receiver)
        end)
end

addr, port = srv:getaddr()
print(addr, port)
print("servidor inicializado.")

-- local mytimer = tmr.create()
-- mytimer:register(1000, tmr.ALARM_AUTO, piscapisca)
-- mytimer:start()