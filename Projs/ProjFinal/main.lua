--Nome: Felipe Pessoa e Guilherme Bizzo
--Matricula: 1411716 e 1710563

-- mqtt library
local mqtt = require("mqtt_library")

-- MapManager module
local MapManager = require 'MapManager'

-- CollisionManager module
local CollisionManager = require 'CollisionManager'

-- Player module
local Player = require 'Player'

-- Shot module
local Shot = require 'Shot'

-- Coin module
local Coin = require 'Coin'

-- Enemy module
local Enemy = require 'Enemy'

local onlineIds = {}
onlineIds[1] = {
        name = "cliente love FG online 1",
        sub = "paraloveFG Online 1",
        send = "paraloveFG Online 2"
    }
onlineIds[2] = {
        name = "cliente love FG online 2",
        sub = "paraloveFG Online 2",
        send = "paraloveFG Online 1"
    }

local clientName = {}
clientName[1] = "cliente love FG 1"
clientName[2] = "cliente love FG 2"

local onlineId = 2
  
local function mqttcb (topic, msg)
    if topic == "paraloveFG" then
        print("topic: "..topic.." msg: "..msg)
        hero.newMessage(msg)
    elseif topic == onlineIds[onlineId].sub then
        local split = splitString(msg, ":")
        if split[1] == "keyreleased" then
            player2.keyreleased(split[2])
        elseif split[1] == "keypressed" then
            player2.keypressed(split[2])
        end
    end
end

-- Declare initial state of game
function love.load()
	-- load map
	map, world = MapManager.InitMap()

    hero = Player.Init()
    player2 = Player.Init()
    
    Shot.Init()
    
    Coin.Init()
    
    Enemy.Init()

    CollisionManager.Init()
    
    --MQTT for controller
     mqtt_client_controller = mqtt.client.create("broker.hivemq.com", 1883, mqttcb)
     mqtt_client_controller = mqtt.client.create("localhost", 1883, mqttcb)
     mqtt_client_controller:connect(clientName[onlineId])
     mqtt_client_controller:subscribe({"paraloveFG"})

    --MQTT for online
    mqtt_client_online = mqtt.client.create("broker.hivemq.com", 1883, mqttcb)
    mqtt_client_online:connect(onlineIds[onlineId].name)
    mqtt_client_online:subscribe({onlineIds[onlineId].sub})
end

function love.update(dt)
    -- Update world
    world:update(dt) 
	
	-- Update world map
    map:update(dt)
    
    -- Updates Player
    hero.update(dt)
    player2.update(dt)
    
    -- Updates Shot
    Shot.update(dt)
    
    -- Updates Enemy
    Enemy.update(dt)

    -- mqtt handler
    -- mqtt_client_controller:handler()
    mqtt_client_online:handler()
end

function love.keyreleased(key)
    -- Sends to Player
    hero.keyreleased(key)

    -- Manda keyreleased para o node
    mqtt_client_online:publish(onlineIds[onlineId].send, "keyreleased:"..key)
end

function love.keypressed(key)
    -- Sends to Player
    hero.keypressed(key)

    -- Manda keypressed para o node
    mqtt_client_online:publish(onlineIds[onlineId].send, "keypressed:"..key)
end

function love.draw()
    heroPosX, heroPosY = hero.body:getPosition();
    local tx,ty = -heroPosX + love.graphics.getWidth()/2, -heroPosY + love.graphics.getHeight() * 3/4;
	
    -- Draw world
	love.graphics.setColor(1, 1, 1)
	map:draw(tx,ty)

	-- Draw Collision Map (useful for debugging)
	love.graphics.setColor(1, 0, 0)
	map:box2d_draw(tx,ty)
  
  -- Texto player
    local text = "Moedas: "..tostring(hero.coins)
    love.graphics.setColor(1, 1, 1)
    font = love.graphics.setNewFont(20)
    love.graphics.print(text, love.graphics.getWidth()/2 - font:getWidth(text)/2, 20)
    
    love.graphics.setColor(255,0,0,255)
    love.graphics.rectangle("fill", 20, 20, hero.health, 20)
    love.graphics.setColor(0,0,0,255)
    love.graphics.rectangle("line", 20, 20, 100, 20)
    
end

function splitString(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end