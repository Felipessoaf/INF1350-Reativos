-- Nome: Felipe Pessoa e Guilherme Bizzo
-- Matricula: 1411716 e 1710563

local discos = { {}, {}, {} }

local function desenha()
  local larg, alt = love.graphics.getDimensions()
  local x, y
  for i = 1, 3 do
    x = i*larg/5 + larg/10
    y = alt
    for j = 1, #discos[i] do
      love.graphics.setColor(1,1,1)
      love.graphics.rectangle ("line", x - discos[i][j]/2, y - alt/15, discos[i][j], alt/15)
      y = y - alt/15
    end
  end
end

local function move (origem, destino)
  local tam = table.remove (discos[origem])
  table.insert (discos[destino], tam)
end

local function hanoi (origem, destino, auxiliar, quantos)
  coroutine.yield()
  if quantos <= 1 then
    move(origem, destino)
  else
    move(origem, auxiliar)
    hanoi(origem, destino, auxiliar, quantos - 1)
    move(auxiliar, destino)
  end
   
end


local function criapilha(from, n)
-- cria pilha com até 10 discos
  for i = 1, n do
    discos[from][i] = 100 - 10*i
  end
end

local totaltempoexib = 1 -- tempo entre trocas
local tempofalta -- conta tempo restante para troca

function love.load(arg)
  ha = coroutine.create(hanoi)
  love.window.setMode (800, 400)
  criapilha(1, 5)
  tempofalta = totaltempoexib
  coroutine.resume(ha)
end

function love.draw()
  love.graphics.setBackgroundColor(0,0,0)
  desenha()
end

function love.update (dt)
  --tempofalta = tempofalta - dt
  --if tempofalta < 0 then
    -- só para demonstrar a move!
    --move (1, 3)
    --tempofalta = totaltempoexib
  --end
  coroutine.resume(ha)
  hanoi(1,3,2,5)
end

function love.quit ()
  os.exit()
end