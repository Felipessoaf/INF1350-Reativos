local meublip
local player

local function newblip (vel)
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
    love.graphics.rectangle("line", x, y, tam, 10)
  end
  }
end

function love.keypressed (key)
  if key == 'space' then
    pos = player.try()
    if meublip.affected(pos) then
      love.event.quit()
    end
  end
end


function love.load()
  player =  newplayer()
  meublip = newblip(5)
end

function love.draw()
  player.draw()
  meublip.draw()
end

function love.update(dt)
  player.update(dt)
  meublip.update(dt)
end
  
function love.quit ()
  love.window.close()
  os.exit()
end
