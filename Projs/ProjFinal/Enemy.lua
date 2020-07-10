--Nome: Felipe Pessoa e Guilherme Bizzo
--Matricula: 1411716 e 1710563

-- Layers module
local Layers = require 'Layers'

local Enemy = {}

function Enemy.Init()
   -- Create new dynamic data layer
    local enemyLayer = map:addCustomLayer(Layers.enemy.name, Layers.enemy.number)	
    
    Enemy.en = {}

	-- Draw player
    enemyLayer.draw = function(self)
        
        for coin, _ in pairs(Enemy.en) do
            love.graphics.setColor(unpack(enemy.color))
            love.graphics.polygon("fill", enemy.body:getWorldPoints(enemy.shape:getPoints()))
            love.graphics.setColor(0, 0, 1)
            love.graphics.polygon("line", enemy.body:getWorldPoints(enemy.shape:getPoints()))
        end
          
		-- Temporarily draw a point at our location so we know
		-- that our sprite is offset properly
		-- love.graphics.setPointSize(5)
		-- love.graphics.points(math.floor(self.hero.body:getX()), math.floor(self.hero.body:getY()))
    end
    
end

function Enemy.update(dt)
  for enemy, _ in pairs(Enemy.en) do
    enemy.update(dt)
  end
end

function Enemy.Create()
	local enemy = {}

	-- Properties
    enemy.tag = "Enemy"
    enemy.initX = 200
    enemy.initY = 200
    enemy.width = 10
    enemy.height = 30
    enemy.color = color
    
	-- Physics
    enemy.body = love.physics.newBody(world, enemy.initX, enemy.initY, "dynamic")
    enemy.body:setFixedRotation(true)
    enemy.body:setGravityScale(0)
    enemy.body:setBullet(true)
    
    enemy.shape = love.physics.newRectangleShape(enemy.width, enemy.height)
    
    enemy.fixture = love.physics.newFixture(enemy.body, enemy.shape, 2)
    enemy.fixture:setUserData({properties = enemy})
    enemy.fixture:setCategory(2)
    enemy.fixture:setSensor(true)
    
    -- Functions
    enemy.update = function(dt)
      enemy.body:setLinearVelocity(enemy.speed*enemy.direction, 0)
    end
    
    enemy.remove = function()
      Enemy.en[enemy] = nil
    end
    
    
    Enemy.en[enemy] = true
    
  end
  
  return Enemy