-- MapManager module
local MapManager = require 'MapManager'

-- CollisionManager module
local CollisionManager = require 'CollisionManager'

-- Player module
local Player = require 'Player'

-- Declare initial state of game
function love.load()
	-- load map
	map, world = MapManager.InitMap()

    hero = Player.Init()

    CollisionManager.Init()
end

function love.update(dt)
    world:update(dt) -- this puts the world into motion
	
	-- Update world map
    map:update(dt)
    
    -- Updates Player
    hero.update(dt)
end

function love.keyreleased(key)
    -- Sends to Player
    hero.keyreleased(key)
end

function love.keypressed(key)
    -- Sends to Player
    hero.keypressed(key)
end

function love.draw()
    heroPosX, heroPosY = hero.body:getPosition();
    local tx,ty = -heroPosX + love.graphics.getWidth()/2, -heroPosY + love.graphics.getHeight() * 3/4;
	
    -- Draw world
	love.graphics.setColor(1, 1, 1)
	map:draw(tx,ty)

	-- Draw Collision Map (useful for debugging)
	love.graphics.setColor(1, 0, 0)
	map:box2d_draw(tx,ty)
end