--------------------------------------------------------------------
-- Example:
-- Blink LED 1 once every second
-- If button 1 is pressed, stop blinking, start blinking, ...
-- Parallel API example
--------------------------------------------------------------------
local tasks = require("tasks")
local led1 = true

function love.load()
  -- main

  local function blink()
    while true do
      tasks.await_ms(500)
      led1 = not led1
    end
  end
  
  local main_task = tasks.task_t:new(
    function()
      while true do
        local exec = tasks.par_or(blink, 
                     function() 
                       tasks.await("space") 
                     end)
        exec()
        tasks.await("space") 
      end
    end
  )
  main_task()
end

function love.update(dt)
  tasks.update_time(dt * 1000)
end

function love.keypressed(key, scancode, isrepeat)
  if isrepeat then return end
  tasks.emit(key)
end

function love.draw()
  love.graphics.setColor(1, 1, 1) -- White
  --                                              x    y    r   segments
  love.graphics.circle(led1 and "fill" or "line", 100, 100, 20, 100)
end

function love.quit()
  os.exit()
end
