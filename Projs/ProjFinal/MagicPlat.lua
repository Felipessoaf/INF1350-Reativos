--Nome: Felipe Pessoa e Guilherme Bizzo
--Matricula: 1411716 e 1710563

-- Layers module
local Layers = require 'Layers'

local MagicPlat = {}

function MagicPlat.Init()
   -- Create new dynamic data layer
    local platsLayer = map:addCustomLayer(Layers.plats.name, Layers.plats.number)
    
    MagicPlat.plats = {}
    
    for k, object in pairs(map.objects) do
        if object.name == "platSpawn" then
            MagicPlat.Create(object.x, object.y)          
        end
    end

    platsLayer.draw = function(self)        
        for plat, _ in pairs(MagicPlat.plats) do
            if not plat.hidden then
                love.graphics.setColor(unpack(plat.color))
                love.graphics.polygon("fill", plat.body:getWorldPoints(plat.shape:getPoints()))
                love.graphics.setColor(198/255, 130/255, 250/255, 0.5)
                love.graphics.polygon("line", plat.body:getWorldPoints(plat.shape:getPoints()))
            end
        end
    end    
end

function MagicPlat.UpdateValue(val)  
    for plat, _ in pairs(MagicPlat.plats) do
        plat.newValue(val)
    end
end

function MagicPlat.Create(x,y)
	local plat = {}

	-- Properties
    plat.tag = "plat"
    plat.initX = x
    plat.initY = y
    plat.width = 40
    plat.height = 20
    plat.color = {178/255, 77/255, 1, 0.5}
    plat.hidden = false
    
	-- Physics
    plat.body = love.physics.newBody(world, plat.initX, plat.initY, "static")
    plat.body:setFixedRotation(true)
    plat.body:setGravityScale(0)
    
    plat.shape = love.physics.newRectangleShape(plat.width, plat.height)
    
    plat.fixture = love.physics.newFixture(plat.body, plat.shape, 2)
    plat.fixture:setUserData({properties = plat})
    plat.fixture:setCategory(2)
    
    -- Functions
    plat.newValue = function(val)
        if val < 10 then
            plat.body:setActive(true)
            plat.hidden = false
        else
            plat.body:setActive(false)
            plat.hidden = true
        end
    end    
    
    MagicPlat.plats[plat] = true    
  end
  
  return MagicPlat