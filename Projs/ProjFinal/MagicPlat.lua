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
            love.graphics.setColor(unpack(plat.color))
            love.graphics.polygon("fill", plat.body:getWorldPoints(plat.shape:getPoints()))
            love.graphics.setColor(198/255, 130/255, 250/255, 0.5)
            love.graphics.polygon("line", plat.body:getWorldPoints(plat.shape:getPoints()))
        end
    end    
end

function MagicPlat.Create(x,y)
	local plat = {}

	-- Properties
    plat.tag = "plat"
    plat.initX = x
    plat.initY = y
    plat.width = 20
    plat.height = 40
    plat.color = {178/255, 77/255, 1, 0.5}
    
	-- Physics
    plat.body = love.physics.newBody(world, plat.initX, plat.initY, "static")
    plat.body:setFixedRotation(true)
    
    plat.shape = love.physics.newRectangleShape(plat.width, plat.height)
    
    plat.fixture = love.physics.newFixture(plat.body, plat.shape, 2)
    plat.fixture:setUserData({properties = plat})
    plat.fixture:setCategory(2)
    
    -- Functions
    plat.newValue = function(val)
        plat.body:setActive(val < 10 and false or true)
    end    
    
    MagicPlat.plats[plat] = true    
  end
  
  return Coin