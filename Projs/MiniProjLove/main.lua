-- Nome: Felipe Pessoa e Guilherme Bizzo
-- Matricula: 1411716 e 1710563

local invadersManager
local player
local shot
local GameState = 0 -- 0, se estiver no menu; 1, se o jogo estiver em andamento; 2, se o jogador vencer ou perder

local function checkCollision(xa, ya, wa, ha, xb, yb, wb, hb)
    return xa + wa >= xb and 
        xa <= xb + wb and 
        ya + ha >= yb and 
        ya <= yb + hb
end

local function wait(seconds)
    while seconds > 0 do
      local tempo = coroutine.yield()
      seconds = seconds - tempo
    end
end

local function newInvader (x, y, color, vel)
    local width, height = 40, 10
    local direction = 1
  
    local function move()
      while true do
        x = x + (20 * direction)
        wait(vel)
      end
    end

    return {
        update = coroutine.wrap(move),

        draw = function ()
            love.graphics.setColor(unpack(color))
            love.graphics.rectangle("fill", x, y, width, height)
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("line", x, y, width, height)
        end,

        getPosX = function()
            return x
        end,

        getPosY = function()
            return y
        end,

        getWidth = function()
            return width
        end,

        getHeight = function()
            return height
        end,

        changeDirection = function()
            direction = direction * -1
        end,

        changeLine = function()
            y = y + 20
        end
        
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

local function createInvaders()
    local screenWidth, screenHeight = love.graphics.getDimensions()
    local invaders = {}
    local canSwitchDirection = false

    local colors = {
        {1, 0, 238/255}, --rosa
        {0, 234/255, 1}, --azul bebe  
        {0, 234/255, 1}, --azul bebe  
        {0, 252/255, 29/255}, --verde    
        {0, 252/255, 29/255}, --verde    
    }

    for i=1,5 do
        for j=1,10 do
            table.insert(invaders, newInvader(j * 50, i * 50, colors[i], 0.2))
        end
    end

    local function insidePath()
        return invaders[#invaders].getPosX() < screenWidth - invaders[#invaders].getWidth()*2 and invaders[1].getPosX() > invaders[#invaders].getWidth()
    end

    return {
        update = function(dt)     
            if #invaders == 0 then
                return
            end
            
            if not insidePath() and canSwitchDirection then
                canSwitchDirection = false
                for i,invader in pairs(invaders) do
                    --troca direçao
                    invader.changeDirection()
                    --descer
                    invader.changeLine()
                end
            end
            
            if insidePath() then
                canSwitchDirection = true
            end

            for i,invader in pairs(invaders) do
                invader.update(dt)
            end
        end,

        draw = function ()
            for i,invader in pairs(invaders) do
                invader.draw()
            end
        end,

        invaders = invaders
    }
end

local function createShot(x, y, vel)
    local screenWidth, screenHeight = love.graphics.getDimensions()
    local width, height = 5, 10

    return {
        update = function (dt)
            y = y - vel * dt

            for i,invader in pairs(invadersManager.invaders) do
                if checkCollision(x, y, width, height, invader.getPosX(), invader.getPosY(), invader.getWidth(), invader.getHeight()) then
                    table.remove(invadersManager.invaders, i)
                end
            end
        end,
        
        draw = function ()
            love.graphics.setColor(246/255, 1, 0)
            love.graphics.rectangle("fill", x, y, width, height)
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("line", x, y, width, height)
        end
    }
end

local function newplayer ()
    local screenWidth, screenHeight = love.graphics.getDimensions()
    local width, height = 50, 20
    local x, y = (screenWidth - width)/2, screenHeight - height
    local vel = 300
    local shots = {}

    return {
        update = function (dt)
            if love.keyboard.isDown("a") then
                x = x - vel * dt
                if x < 0 then
                    x = 0
                end
            end
            
            if love.keyboard.isDown("d") then
                x = x + vel * dt
                if x > screenWidth - width then
                    x = screenWidth - width
                end
            end

            for i,shot in pairs(shots) do
                shot.update(dt)
            end
        end,

        keypressed = function(key)
            if key == 'space' then
                --atira--
                table.insert( shots,createShot(x, y, 500))
            end
        end,
        
        draw = function ()
            love.graphics.setColor(0, 1, 34/255)
            love.graphics.rectangle("fill", x, y, width, height)
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("line", x, y, width, height)

            for i,shot in pairs(shots) do
                shot.draw()
            end
        end
    }
end

function love.keypressed (key)
    player.keypressed(key)
end

function love.load()
    player =  newplayer()
    
    invadersManager = createInvaders()
end

function love.draw()
    player.draw()

    invadersManager.draw()    
end

function love.update(dt)
    player.update(dt)

    invadersManager.update(dt)   
end
