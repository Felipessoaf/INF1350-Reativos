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
        --trata msg "1", "2", etc para move esquerda, move direita, pula, etc
        print("topic: "..topic.." msg: "..msg)
        hero.newMessage(msg)
    end
end

-- Declare initial state of game
function love.load()
	-- load map
	map, world = MapManager.InitMap()

    hero = Player.Init()
    
    Shot.Init()

    CollisionManager.Init()
    

    mqtt_client = mqtt.client.create("broker.hivemq.com", 1883, mqttcb)
    mqtt_client:connect("cliente love FG")
    mqtt_client:subscribe({"paraloveFG"})
end

function love.update(dt)
    -- Update world
    world:update(dt) 
	
	-- Update world map
    map:update(dt)
    
    -- Updates Player
    hero.update(dt)
    
    -- Updates Shot
    Shot.update(dt)

    -- mqtt handler
    mqtt_client:handler()
end

function love.keyreleased(key)
    -- Sends to Player
    hero.keyreleased(key)
end

function love.keypressed(key)
    -- Sends to Player
    hero.keypressed(key)

    -- Se precisar mandar algo para o node
    mqtt_client:publish("paranodeFG", key)
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