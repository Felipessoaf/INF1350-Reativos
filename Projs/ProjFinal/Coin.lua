--Nome: Felipe Pessoa e Guilherme Bizzo
--Matricula: 1411716 e 1710563

-- Layers module
local Layers = require 'Layers'

local Coin = {}

function Coin.Init()
   -- Create new dynamic data layer
    local coinLayer = map:addCustomLayer(Layers.coin.name, Layers.coin.number)
    
    Coin.moedas = {}
    
    for k, object in pairs(map.objects) do
        if object.name == "coinSpawn" then
            Coin.Create(object.x, object.y)          
        end
    end

    coinLayer.draw = function(self)        
        for coin, _ in pairs(Coin.moedas) do
            local cx, cy = coin.body:getWorldPoints(coin.shape:getPoint())
            love.graphics.setColor(unpack(coin.color))
            love.graphics.circle("fill", cx, cy, coin.shape:getRadius())
            love.graphics.setColor(0, 0, 0)
            love.graphics.circle("line", cx, cy, coin.shape:getRadius())
        end
    end    
end

function Coin.update(dt)
    for coin, state in pairs(Coin.moedas) do
        if state == false then
            coin.body:setActive(false)
            Coin.moedas[coin] = nil
        end
    end
end

function Coin.Create(x,y)
	local coin = {}

	-- Properties
    coin.tag = "Coin"
    coin.initX = x
    coin.initY = y
    coin.radius = 7
    coin.color = {1,1,0}
    
	-- Physics
    coin.body = love.physics.newBody(world, coin.initX, coin.initY, "dynamic")
    coin.body:setFixedRotation(true)
    coin.body:setGravityScale(0)
    
    coin.shape = love.physics.newCircleShape(coin.radius)
    
    coin.fixture = love.physics.newFixture(coin.body, coin.shape, 2)
    coin.fixture:setUserData({properties = coin})
    coin.fixture:setCategory(2)
    coin.fixture:setSensor(true)
    
    -- Functions    
    coin.remove = function()
        Coin.moedas[coin] = false
    end    
    
    Coin.moedas[coin] = true    
  end
  
  return Coin