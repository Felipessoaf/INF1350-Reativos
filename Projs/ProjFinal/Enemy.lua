--Nome: Felipe Pessoa e Guilherme Bizzo
--Matricula: 1411716 e 1710563

-- Layers module
local Layers = require 'Layers'

local Shot = require 'Shot'

local Enemy = {}

function Enemy.Init()
   -- Create new dynamic data layer
    local enemyLayer = map:addCustomLayer(Layers.enemy.name, Layers.enemy.number)	
    
    Enemy.enemies = {}

    for k, object in pairs(map.objects) do
        if object.name == "enemySpawn" then
            Enemy.Create(object.x, object.y)          
        end
    end

    enemyLayer.draw = function(self)        
        for enemy, _ in pairs(Enemy.enemies) do
            love.graphics.setColor(unpack(enemy.color))
            love.graphics.polygon("fill", enemy.body:getWorldPoints(enemy.shape:getPoints()))
            love.graphics.setColor(0, 0, 0)
            love.graphics.polygon("line", enemy.body:getWorldPoints(enemy.shape:getPoints()))
        end
    end
    
end

function Enemy.update(dt)
    for enemy, state in pairs(Enemy.enemies) do
        if state == false then
            enemy.body:setActive(false)
            Enemy.enemies[enemy] = nil
        else
            enemy.update(dt)
        end
    end
end

function Enemy.Create(x,y)
	local enemy = {}

	-- Properties
    enemy.tag = "Enemy"
    enemy.initX = x
    enemy.initY = y
    enemy.width = 20
    enemy.height = 40
    enemy.color = {247/255, 153/255, 0}
    enemy.shotTime = 0
    enemy.nextShotInterval = math.random()
    
	-- Physics
    enemy.body = love.physics.newBody(world, enemy.initX, enemy.initY, "dynamic")
    enemy.body:setFixedRotation(true)
    
    enemy.shape = love.physics.newRectangleShape(enemy.width, enemy.height)
    
    enemy.fixture = love.physics.newFixture(enemy.body, enemy.shape, 2)
    enemy.fixture:setUserData({properties = enemy})
    enemy.fixture:setCategory(2)
    
    -- Functions
    enemy.update = function(dt)
        local currentTime = love.timer:getTime()
        if currentTime > enemy.shotTime + enemy.nextShotInterval then
            Shot.Create(enemy.body:getX(), enemy.body:getY(), {1,0,1}, hero.body:getX() < enemy.body:getX() and -1 or 1, "EnemyShot")
            enemy.shotTime = currentTime
            enemy.nextShotInterval = math.random()*2
            
            -- mqtt_client_controller:publish("paranodeFG", "enemyShot")
        end
    end
    
    enemy.remove = function()
        Enemy.enemies[enemy] = false
    end
        
    Enemy.enemies[enemy] = true    
  end
  
  return Enemy