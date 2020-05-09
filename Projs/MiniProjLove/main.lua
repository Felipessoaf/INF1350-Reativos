-- Nome: Felipe Pessoa e Guilherme Bizzo
-- Matricula: 1411716 e 1710563

local invaders = {}
local player
local shot
local GameState = 0 -- 0, se estiver no menu; 1, se o jogo estiver em andamento; 2, se o jogador vencer ou perder

local function newInvader (x, y, color, vel)
    local tam = 40

    return {
        update = function (dt)
        
        end,

        draw = function ()
            love.graphics.setColor(unpack(color))
            love.graphics.rectangle("fill", x, y, tam, tam/4)
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("line", x, y, tam, tam/4)
        end,
        
        --affected = function (pos)
            --if pos>x and pos<x+50 then
            -- atingiu o invader --
                --return true
            --else
            -- errou o tiro --
                --return false
            --end
        --end
    }
    
    
    end

local function newplayer ()
    local screenWidth, screenHeight = love.graphics.getDimensions()
    local width, height = 50, 20
    local x, y = (screenWidth - width)/2, screenHeight - height

    return {
        update = function (dt)
            
        end,
        
        draw = function ()
            love.graphics.setColor(0, 1, 34/255)
            love.graphics.rectangle("fill", x, y, width, height)
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("line", x, y, width, height)
        end
    }
end

--local function shot()
--  local screenWidth, screenHeight = love.graphics.getDimensions()
--  local width, height = 20, 40
--  local x, y = (screenWidth - width)/2, screenHeight - height + 20 

--  return {
--      update = function (dt)
          
--      end,
      
--      draw = function ()
--          love.graphics.setColor(0, 1, 34/255)
--          love.graphics.rectangle("fill", x, y, width, height)
--          love.graphics.setColor(1, 1, 1)
--         love.graphics.rectangle("line", x, y, width, height)
--      end
--  }
--end

function love.keypressed (key)
    if key == 'space' then
      --atira--
      --shot.draw()
    end
    if key == 'a' then
      --player.x -= 10
    end
    if key == 'd' then
      --player.x += 10
    end
end


function love.load()
    player =  newplayer()

    local colors = {
        {1, 0, 238/255}, --rosa
        {0, 234/255, 1}, --azul bebe  
        {0, 234/255, 1}, --azul bebe  
        {0, 252/255, 29/255}, --verde    
        {0, 252/255, 29/255}, --verde    
    }
    
    for i=1,5 do
        for j=1,10 do
            table.insert(invaders, newInvader(j * 50, i * 50, colors[i]))
        end
    end
end

function love.draw()
    player.draw()

    for i,invader in pairs(invaders) do
        invader.draw()
    end
    
end

function love.update(dt)
    player.update(dt)
end
