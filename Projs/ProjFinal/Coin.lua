--Nome: Felipe Pessoa e Guilherme Bizzo
--Matricula: 1411716 e 1710563

-- Layers module
local Layers = require 'Layers'

local Coin = {}

function Coin.Init()
   -- Create new dynamic data layer
    local coinLayer = map:addCustomLayer(Layers.coin.name, Layers.coin.number)	
    
    --local spawn
    --for k, object in pairs(map.objects) do
        --if object.name == "spawnPoint" then
          --spawn = object
          --break
        --end
    --end
    
    Coin.moedas = {}

	-- Draw player
    coinLayer.draw = function(self)
        
        for coin, _ in pairs(Coin.moedas) do
            love.graphics.setColor(unpack(coin.color))
            love.graphics.polygon("fill", coin.body:getWorldPoints(coin.shape:getPoints()))
            love.graphics.setColor(0, 0, 1)
            love.graphics.polygon("line", coin.body:getWorldPoints(coin.shape:getPoints()))
        end
          
		-- Temporarily draw a point at our location so we know
		-- that our sprite is offset properly
		-- love.graphics.setPointSize(5)
		-- love.graphics.points(math.floor(self.hero.body:getX()), math.floor(self.hero.body:getY()))
    end
    
end

function Coin.update(dt)
  for coin, _ in pairs(Coin.moedas) do
    coin.update(dt)
  end
end

function Coin.Create()
	local coin = {}

	-- Properties
    coin.tag = "Coin"
    coin.initX = 120
    coin.initY = 120
    coin.width = 10
    coin.height = 10
    coin.color = color
    
	-- Physics
    coin.body = love.physics.newBody(world, coin.initX, coin.initY, "dynamic")
    coin.body:setFixedRotation(true)
    coin.body:setGravityScale(0)
    coin.body:setBullet(true)
    
    coin.shape = love.physics.newRectangleShape(coin.width, coin.height)
    
    coin.fixture = love.physics.newFixture(coin.body, coin.shape, 2)
    coin.fixture:setUserData({properties = coin})
    coin.fixture:setCategory(2)
    coin.fixture:setSensor(true)
    
    -- Functions
    coin.update = function(dt)
      coin.body:setLinearVelocity(coin.speed*coin.direction, 0)
    end
    
    coin.remove = function()
      Coin.moedas[coin] = nil
    end
    
    
    Coin.moedas[coin] = true
    
  end
  
  return Coin