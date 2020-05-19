--Nome: Felipe Pessoa e Guilherme Bizzo
--Matricula: 1411716 e 1710563

local meuid = "abacateverde"
local m = mqtt.Client("clientid " .. meuid, 120)

-- function publica(c)
--   c:publish("inf1350-a","alo de " .. meuid,0,0, 
--             function(client) print("mandou!") end)
-- end

function novaInscricao (c)
  local msgsrec = 0
  local function novamsg (c, t, m)
    print ("mensagem ".. msgsrec .. ", topico: ".. t .. ", dados: " .. m)
    msgsrec = msgsrec + 1
  end
  c:on("message", novamsg)
end

function conectado (client)
  publica(client)
  client:subscribe("paranode", 0, novaInscricao)
end 

m:connect("broker.hivemq.com", 1883, false, 
             conectado,
             function(client, reason) print("failed reason: "..reason) end)