--Nome: Felipe Pessoa e Guilherme Bizzo
--Matricula: 1411716 e 1710563

-- Layers module
local Layers = require 'Layers'

local Player = {}

-- Maps keys to players and directions
local keyMap = {
  a = -1,
  d = 1
}

function Player.Init()
   -- Create new dynamic data layer
    local playerLayer = map:addCustomLayer(Layers.player.name, Layers.player.number)

	-- Get player spawn object
	local spawn
	for k, object in pairs(map.objects) do
		if object.name == "spawnPoint" then
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
    hero.jumpCount = 2
    
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
        local currentVelX, currentVelY = hero.body:getLinearVelocity()
        hero.body:setLinearVelocity(hero.speed*direction, currentVelY)
    end

    hero.stopHorMove = function ()
        currentVelX, currentVelY = hero.body:getLinearVelocity()
        hero.body:setLinearVelocity(0, currentVelY)
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
        
        mqtt_client:publish("paranodeFG", "jump")
    end

    hero.newMessage = function (msg)
        if msg == "btn1" and hero.jumpCount > 0 then
            hero.jump()
        end
    end

    hero.update = function (dt)
        -- keyboard actions for our hero
        for _, key in pairs({'a', 'd'}) do
            if love.keyboard.isDown(key) then
                hero.move(keyMap[key])
            end
        end
    end

    -- hero.keypressed = function (key)
    --     if key == 'w' and hero.jumpCount > 0 then
    --         hero.jump()
    --     end
    -- end

    -- hero.keyreleased = function (key)
    --     if key == 'a' or  key == 'd' then
    --         hero.stopHorMove()
    --     end
    -- end

	-- Draw player
    playerLayer.draw = function(self)
        
        love.graphics.setColor(117/255, 186/255, 60/255)
        love.graphics.polygon("fill", hero.body:getWorldPoints(hero.shape:getPoints()))
        love.graphics.setColor(0, 0, 0)
        love.graphics.polygon("line", hero.body:getWorldPoints(hero.shape:getPoints()))

		-- Temporarily draw a point at our location so we know
		-- that our sprite is offset properly
		-- love.graphics.setPointSize(5)
		-- love.graphics.points(math.floor(self.hero.body:getX()), math.floor(self.hero.body:getY()))
    end
    
	-- Remove unneeded object layer
	map:removeLayer("spawn")

    return hero
end

return Player