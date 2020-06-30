--Nome: Felipe Pessoa e Guilherme Bizzo
--Matricula: 1411716 e 1710563

-- Layers module
local Layers = require 'Layers'

local Shot = require 'Shot'

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
    hero.direction = 0
    hero.jumpCount = 2
    hero.color = {117/255, 186/255, 60/255}
    hero.shotDirection = 1
    
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
        
        mqtt_client:publish("paranodeFG", "jump")
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
        elseif msg == "lum" then
            local lumValue = tonumber(split[2])
            if lumValue < 50 then
                hero.color = {0,0,0}
            elseif lumValue >= 50 then
                hero.color = {1,1,1}
            end
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
          Shot.Create(hero.body:getX(), hero.body:getY(), {1,1,1}, hero.shotDirection)
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