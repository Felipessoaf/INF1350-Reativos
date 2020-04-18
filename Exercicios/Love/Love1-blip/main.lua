local blips = {}
local player
local GameState = 1
local GameTexts = {
    "INIMIGOS FALTANDO: "..#blips,
    "GANHOU!",
    "PERDEU!"
}

local function newblip (vel, color)
    local x, y = 0, 0
    local tam = 40

    return {
        update = function (dt)
            local width, _ = love.graphics.getDimensions( )
            x = x+(vel+1)*dt*40
            if x > width then
                -- volta para a esquerda da janela
                x = 0
            end
        end,

        affected = function (pos)
            if pos>x and pos<x+tam then
            -- "pegou" o blip
                return true
            else
                return false
            end
        end,

        draw = function ()
            if immortal then
                love.graphics.setColor(1, 25/255, 0)
            else
                love.graphics.setColor(unpack(color))
            end
            love.graphics.rectangle("fill", x, y, tam, 10)
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("line", x, y, tam, 10)
        end
    }
    end

local function newplayer ()
    local x, y = 0, 200
    local tam = 30
    local width, height = love.graphics.getDimensions( )

    return {
        try = function ()
            return x + tam/2
        end,

        update = function (dt)
            x = x + 0.5*30*dt
            if x > width then
                x = 0
            end
        end,
        
        draw = function ()
            love.graphics.setColor(0, 1, 34/255)
            love.graphics.rectangle("fill", x, y, tam, 10)
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("line", x, y, tam, 10)
        end
    }
end

function love.keypressed (key)
    if key == 'space' then
        pos = player.try()

        for i,blip in pairs(blips) do
            if blip.affected(pos) then
                table.remove(blips, i)
            end
        end

        if #blips == 0 then
            GameState = 2
        else
            GameState = 1
            GameTexts[1] = "INIMIGOS FALTANDO: "..#blips
        end
    end
end


function love.load()
    player =  newplayer()

    local colors = {
        {154/255, 170/255, 252/255}, --azul/lilas claro
        {218/255, 154/255, 252/255}, --rosa claro
        {143/255, 239/255, 242/255}, --azul bebe    
        {235/255, 61/255, 177/255},  --rosa escuro
        {243/255, 245/255, 157/255}  --bege claro
    }
    
    for i=1,5 do
        table.insert(blips, newblip(math.random(1,10), colors[i]))
    end

    GameTexts[1] = "INIMIGOS FALTANDO: "..#blips
end

function love.draw()
    if GameState == 1 then
        player.draw()

        for i,blip in pairs(blips) do
            blip.draw()
        end
    end

    love.graphics.setColor(1, 243*255, 10/255)
    local width, height = love.graphics.getDimensions()
    love.graphics.setNewFont(35)
    love.graphics.print(GameTexts[GameState], width*1/3, height*3/4)
end

function love.update(dt)
    player.update(dt)

    for i,blip in pairs(blips) do
        blip.update(dt)
    end
end
  
function love.quit ()
    love.window.close()
    os.exit()
end
