--Nome: Felipe Pessoa e Guilherme Bizzo
--Matricula: 1411716 e 1710563

-- Layers module
local Layers = require 'Layers'

-- Shot module
local Shot = require 'Shot'

-- MagicPlat module
local MagicPlat = require 'MagicPlat'

local Player = {}

-- Maps keys to players and directions
local keyMap = {
  a = -1,
  d = 1
}

function Player.Init(spawnName, color)
   -- Create new dynamic data layer
    local playerLayer = map:addCustomLayer(Layers.player.name, Layers.player.number)

	-- Get player spawn object
	local spawn
	for k, object in pairs(map.objects) do
		if object.name == spawnName then
			spawn = object
			break
		end
	end
    
    -- Create hero table
	local hero = {}

	-- Properties
    hero.tag = "Hero"
    hero.initX = spawn.x
    hero.initY = spawn.y
    hero.width = 20
    hero.height = 30
    hero.speed = 150
    hero.direction = 0
    hero.jumpCount = 2
    hero.color = color
    hero.originalColor = color
    hero.shotDirection = 1
    hero.coins = 0
    hero.health = 100
    
	-- Physics
    hero.body = love.physics.newBody(world, hero.initX, hero.initY, "dynamic")
    hero.body:setFixedRotation(true)
    hero.shape = love.physics.newRectangleShape(hero.width, hero.height)
    hero.fixture = love.physics.newFixture(hero.body, hero.shape, 2)
    hero.fixture:setUserData({properties = hero})
    hero.fixture:setCategory(2)
    hero.fixture:setFriction(1)
    
    -- Functions
    hero.move = function (direction)
        hero.direction = direction
        if direction ~= 0 then
          hero.shotDirection = direction
        end
    end
    
    hero.jump = function ()
        -- Sets y velocity to 0
        currentVelX, currentVelY = hero.body:getLinearVelocity()
        hero.body:setLinearVelocity(currentVelX, 0)

        -- Applies impulse
        hero.body:applyLinearImpulse(0, -100)

        -- Decrement jumpCount
        hero.jumpCount = hero.jumpCount - 1

        -- Clamp 0..hero.jumpCount
        hero.jumpCount = (hero.jumpCount < 0 and 0 or hero.jumpCount)
        
        mqtt_client_controller:publish("paranodeFG", "jump")
    end
    
    hero.damage = function(dmg)
        hero.health = hero.health - dmg
        if hero.health <= 0 then
            GameState = 1
        end
    end

    hero.shoot = function()
        Shot.Create(hero.body:getX(), hero.body:getY(), {1,1,1}, hero.shotDirection, "PlayerShot")
        mqtt_client_controller:publish("paranodeFG", "shot")
    end    
    
    hero.newMessage = function (message)
        local split = splitString(message, ":")
        local msg = split[1]

        if msg == "btn1_down" then
            hero.move(-1)
        elseif msg == "btn2_down" then
            hero.move(1)
        elseif msg == "btn1_up" or msg == "btn2_up" then
            hero.move(0)
        elseif msg == "btn3" and hero.jumpCount > 0 then
            hero.jump()
        elseif msg == "btn4" then
            hero.shoot()
        elseif msg == "lum" then
            local lumValue = tonumber(split[2])
            if lumValue < 10 then
                hero.color = {52/255, 82/255, 28/255}
            elseif lumValue >= 10 then
                hero.color = hero.originalColor
            end

            MagicPlat.UpdateValue(lumValue)
        end
    end

    hero.update = function (dt)
        local currentVelX, currentVelY = hero.body:getLinearVelocity()
        hero.body:setLinearVelocity(hero.speed*hero.direction, currentVelY)
    end

    hero.keypressed = function (key)
         if key == 'a' or key == 'd' then
           hero.move(keyMap[key])
        end
        if key == 'w' and hero.jumpCount > 0 then
            hero.jump()
        end
        if key == 'space' then
            hero.shoot()
        end
    end

    hero.keyreleased = function (key)
        if key == 'a' or key == 'd' then
            hero.move(0)
        end
    end

	-- Draw player
    playerLayer.draw = function(self)        
        love.graphics.setColor(unpack(hero.color))
        love.graphics.polygon("fill", hero.body:getWorldPoints(hero.shape:getPoints()))
        love.graphics.setColor(0, 0, 0)
        love.graphics.polygon("line", hero.body:getWorldPoints(hero.shape:getPoints()))
    end
    
	-- Remove unneeded object layer
	-- map:removeLayer("spawn")

    return hero
end

return Player