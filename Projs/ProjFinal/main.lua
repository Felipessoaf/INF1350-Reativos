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
  
local function mqttcb (topic, msg)
    if topic == "paraloveFG" then
        print("topic: "..topic.." msg: "..msg)
        hero.newMessage(msg)
    end
end

local onlineIds = {
    "1" = {
        sub = "paraloveFG Online 1",
        send = "paraloveFG Online 2"
    },
    "2" = {
        sub = "paraloveFG Online 2",
        send = "paraloveFG Online 1"
    },
}

local onlineId = 1

-- Declare initial state of game
function love.load()
	-- load map
	map, world = MapManager.InitMap()

    hero = Player.Init()
    player2 = Player.Init()
    
    Shot.Init()

    CollisionManager.Init()
    
    --MQTT for controller
    -- mqtt_client_controller = mqtt.client.create("broker.hivemq.com", 1883, mqttcb)
    mqtt_client_controller = mqtt.client.create("localhost", 1883, mqttcb)
    mqtt_client_controller:connect("cliente love FG")
    mqtt_client_controller:subscribe({"paraloveFG"})

    --MQTT for online
    mqtt_client_online = mqtt.client.create("broker.hivemq.com", 1883, mqttcb)
    mqtt_client_online:connect("cliente love FG online")
    mqtt_client_online:subscribe({onlineIds.onlineId.sub})
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

    -- mqtt handler
    mqtt_client_controller:handler()
    mqtt_client_online:handler()
end

function love.keyreleased(key)
    -- Sends to Player
    hero.keyreleased(key)
end

function love.keypressed(key)
    -- Sends to Player
    hero.keypressed(key)

    -- Manda keypressed para o node
    mqtt_client_online:publish(onlineIds.onlineId.send, key)
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