local srv = net.createServer(net.TCP) 

local function receiver(sck, request) 
    print("recebeu:\n" .. request) 
    local buf = [[
        INF1350 - PUC Rio
        ESP8266 Web Server

        boa tarde!
        ]] 

    sck:send(buf, function() -- callback: fecha o socket qdo acabar de enviar resposta 
        print("respondeu") 
        sck:close() 
    end) 
end 

if srv then 
    srv:listen(80, function(conn) 
        print("cliente conectado!") 
        conn:on("receive", receiver) 
    end) 
end 

print("servidor inicializado") 