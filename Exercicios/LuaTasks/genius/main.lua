--------------------------------------------------------------------
-- Example:
-- genius:
-- generate random sequence of numbers
-- wait for user to press keys and check whether sequence is the same
-- if user presses "q" at any time quit program
-- if user presses "n" during sequence generation, start new sequence
-- Parallel API example
--------------------------------------------------------------------

local tasks = require("tasks")

local await = tasks.await
local emit = tasks.emit
local await_ms = tasks.await_ms
local update_time = tasks.update_time
local par_or = tasks.par_or
local par_and = tasks.par_and

local interval = 500
local seq = {}
local tamseq = 4

local SIZE = 400
local colors = {}
colors[1] = {
  {0.6, 0, 0},
  {1,0,0}
}
colors[2] = {
  {0.35,0.4,0.2},
  {0.5,1,0}
}
local switches = {}
local numswitches = 2

local function indisk (disk, mx, my)
    return math.sqrt((mx-disk.x)^2 + (my-disk.y)^2) < disk.r
end

local function showswitch (i)
    switches[i].colors =colors[i][2]
    await_ms(300)
    switches[i].colors = colors[i][1]
end


function love.load()
    -- inicia janela com botoes

    love.window.setMode(SIZE,SIZE)
    love.graphics.setBackgroundColor(0,0,0)

    for i = 1, numswitches do
        switches[i] = {colors = colors[i][1], x = i*SIZE/3, y = SIZE/2, r = SIZE/8}
    end
    love.math.setRandomSeed (os.time())

    -- "main"

    local main_task = tasks.task_t:new(
        function()
            while true do  
                local exec = tasks.par_or(function() 
                    print("novo jogo!")
                    await_ms(500)
                    for i = 1, tamseq do
                        seq[i] = love.math.random(1,numswitches)
                        print(seq[i])
                        showswitch(seq[i])
                        await_ms(500)
                    end
                    print("-- agora usuario repete --")
                    for i = 1, tamseq do
                        local key = await ("switchpressed")
                        showswitch(key)
                        if key ~= seq[i] then
                            print ("errou!")
                            break
                        end
                    end
                end, 
                    function() 
                        local key = await("keypressed")
                        while key ~= "q" do
                            key = await("keypressed")
                        end
                        print ("sair do jogo")
                        love.event.quit()
                    end
                )
                exec()                
            end
        end
    )
	main_task()
end

function love.update(dt)
    update_time(dt * 1000)
end

function love.draw ()
    for i = 1, numswitches do
        love.graphics.setColor(switches[i].colors[1], switches[i].colors[2], switches[i].colors[3])
        love.graphics.circle ("fill", switches[i].x, switches[i].y, switches[i].r, 64)
    end
end

function love.mousepressed (mx, my)
    for i = 1, numswitches do
        if indisk (switches[i], mx, my) then
            print ("switchpressed", i)
            emit ("switchpressed", i)
        end
    end
end

function love.keypressed(key, scancode)
    print ("keypressed", key)
    emit("keypressed", key)
end
