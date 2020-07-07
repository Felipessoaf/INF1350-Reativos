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
local moves = {}

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
    local lum = readlum()
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
    
    -- Beeps
    if m == "jump" then
        beep(500, 100)
    end
    
    --if m == "shot" then
        --beep(500,50)
    --end
    
    --if player colidir com coin then
        --beep(500, 300)
    --end
    
    --if player colidir com tiro do inimigo
        --beep(500, 50)
    --end
    
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
        local msg = level == 1 and "btn1_up" or "btn1_down"
        table.insert(moves, msg)
        sendButton(function ()
            publica(client, msg)
        end)
    end)

    gpio.trig(sw2, "both", function (level)
        local msg = level == 1 and "btn2_up" or "btn2_down"
        table.insert(moves, msg)
        sendButton(function ()
            publica(client, msg)
        end)
    end)

    gpio.trig(sw3, "down", function ()
        local msg = "btn3"
        table.insert(moves, "btn3")
        sendButton(function ()
            publica(client, "btn3")
        end)
    end)

    gpio.trig(sw4, "down",  function ()
        local msg = "btn4"
        table.insert(moves, "btn4")
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
local lastlum = 0

function readlum()
    lastlum = 100 - (adc.read(ldr)/10.24)
    return lastlum
end

function toggleBlock()
    blocked = not blocked
end

local actions = {
    LERLUM = readlum,
    TOGGLEBLOCK = toggleBlock,
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
        BLOCKED = tostring(blocked),
    }
  

    local buf = [[
    <html>
    <body>
    <h1><u>Projeto Final INF1350 - Felipe e Guilherme</u></h1>
    <h2>Gerenciador do controle</h2>
            <p>Luminosidade: $LUM <a href="?pin=LERLUM"><button><b>REFRESH</b></button></a>
            <p>Bloqueado: $BLOCKED <a href="?pin=TOGGLEBLOCK"><button><b>TOGGLE</b></button></a>
            <p>Movimentos:<br>
            ###
    </body>
    </html>
    ]]

    
    for index, move in ipairs (moves) do
        buf = string.gsub(buf, "###", "<b>"..tostring(index)..":</b> "..move.."<br>###")
    end

    buf = string.gsub(buf, "###", "")

    
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