--Nome: Felipe Pessoa e Guilherme Bizzo
--Matricula: 1411716 e 1710563

local figuras = {}

local limite = 3

local figurasCoroutines = {}

local function novafigura (x, y, larg, alt, tempoexib)
-- nova figura deve existir no retangulo
-- com canto superior esquerdo em x e y
  local partes
  local st = true
  local tempofalta = tempoexib
  
  local function esperaTempo()
    while tempofalta > 0 do
      local tempo = coroutine.yield()
      tempofalta = tempofalta - tempo
    end
    tempofalta = tempoexib
  end
  
  local function main (dt)
          local espera 
          partes = {}
          
          esperaTempo()
          table.insert (partes, {tipo = "rect",
                                 x = x,
                                 y = y,
                                 w = larg,
                                 h = alt
                                })
                              
          esperaTempo()
          table.insert (partes, {tipo = "circ",
                                 x = x + larg/3,
                                 y = y + 2*(alt/5),
                                 r = math.min(larg/10, alt/10)
                                })
                              
          esperaTempo()
          table.insert (partes, {tipo = "circ",
                                 x = x + 2*(larg/3),
                                 y = y + 2*(alt/5),
                                 r = math.min(larg/10, alt/10)
                                })
                              
          esperaTempo()
          table.insert (partes, {tipo = "rect",
                                 x = x + (larg/2) - larg/10,
                                 y = y + 2*(alt/3) - alt/20,
                                 w = larg/5,
                                 h = alt/10
                                })
        end
  
  return { 
    update = main,

    draw = function ()
             for _, p in ipairs(partes) do
               if p.tipo == "rect" then
                 love.graphics.rectangle ("line", p.x, p.y, p.w, p.h)
               elseif p.tipo == "circ" then
                 love.graphics.circle ("line", p.x, p.y, p.r)
               end
             end
           end
  }
end


function love.load()
  figuras = {}
  tempofalta = tempoexib
  local w, h = love.graphics.getDimensions()
  for i=1, limite do
    figuras[i] = novafigura(i*(w/20 + w/10), h/2-h/20, w/10, h/10, i)
    figurasCoroutines[i] = coroutine.create(figuras[i].update)
    coroutine.resume(figurasCoroutines[i])
  end
  
end 


function love.update (dt)
  --for i = 1, #figuras do
   -- figuras[i].update(dt)
  --end
    for i=1, limite do
      coroutine.resume(figurasCoroutines[i], dt)
    end

end

function love.draw()
  for i = 1, #figuras do
    figuras[i].draw()
  end
end

function love.quit ()
  os.exit()
end