--Nome: Felipe Pessoa e Guilherme Bizzo
--Matricula: 1411716 e 1710563

-- Layers module
local Layers = require 'Layers'

local Shot = {}

function Shot.Init()
   -- Create new dynamic data layer
    local shotLayer = map:addCustomLayer(Layers.shot.name, Layers.shot.number)

    Shot.shots = {}

    shotLayer.draw = function(self)        
        for shot, _ in pairs(Shot.shots) do
            love.graphics.setColor(unpack(shot.color))
            love.graphics.polygon("fill", shot.body:getWorldPoints(shot.shape:getPoints()))
            love.graphics.setColor(0, 0, 0)
            love.graphics.polygon("line", shot.body:getWorldPoints(shot.shape:getPoints()))
        end
    end    
end

function Shot.update(dt)
    for shot, _ in pairs(Shot.shots) do
        shot.update(dt)
    end
end

function Shot.Create(x, y, color, direction, tag)
    local shot = {}

	-- Properties
    shot.tag = tag
    shot.initX = x
    shot.initY = y
    shot.width = 5
    shot.height = 5
    shot.speed = 150
    shot.direction = direction
    shot.color = color
    
	-- Physics
    shot.body = love.physics.newBody(world, shot.initX, shot.initY, "dynamic")
    shot.body:setFixedRotation(true)
    shot.body:setGravityScale(0)
    shot.body:setBullet(true)
    
    shot.shape = love.physics.newRectangleShape(shot.width, shot.height)
    
    shot.fixture = love.physics.newFixture(shot.body, shot.shape, 2)
    shot.fixture:setUserData({properties = shot})
    shot.fixture:setCategory(2)
    shot.fixture:setSensor(true)
    
    -- Functions
    shot.update = function(dt)
        shot.body:setLinearVelocity(shot.speed*shot.direction, 0)
    end
    
    shot.remove = function()
        Shot.shots[shot] = nil
    end    
    
    Shot.shots[shot] = true    
  end
  
  return Shot