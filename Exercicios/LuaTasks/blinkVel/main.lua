--Nome: Felipe Pessoa e Guilherme Bizzo
--Matricula: 1411716 e 1710563

local tasks = require("tasks")

local await = tasks.await
local emit = tasks.emit
local await_ms = tasks.await_ms
local update_time = tasks.update_time
local par_or = tasks.par_or
local par_and = tasks.par_and

local led1 = true
local interval = 500
local SIZE = 400

function love.load()
    love.window.setMode(SIZE,SIZE)
    love.graphics.setBackgroundColor(0,0,0)

    local function blink()
        while true do
            tasks.await_ms(interval)
            led1 = not led1
        end
    end
    
    local main_task = tasks.task_t:new(
        function()
            while true do
                local exec = tasks.par_or(blink, 
                    function() 
                        local key = await ("keyreleased")
                        if key == "h" then
                            print("speed up")
                            interval = interval/2
                            if interval < 100 then
                                interval = 100
                            end
                        elseif key == "l" then
                            print("speed down")
                            interval = interval*2
                            if interval > 2000 then
                                interval = 2000
                            end
                        end
                    end)
                exec()
            end
        end
    )
    main_task()
end

function love.update(dt)
    update_time(dt * 1000)
end

function love.keyreleased(key)
    print("keyreleased", key)
    emit("keyreleased", key)
end

function love.draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.circle(led1 and "fill" or "line", SIZE/2, SIZE/2, 100, 100)
end