--Nome: Felipe Pessoa e Guilherme Bizzo
--Matricula: 1411716 e 1710563

local CollisionManager = {}

function CollisionManager.Init()
    -- Collision callbacks:
    world:setCallbacks(beginContact, endContact, preSolve, postSolve)
end

function beginContact(a, b, coll)  
    -- Trata reset do grounded para pulo
    if (a:getUserData().properties.Ground == true and b:getUserData().properties.tag == "Hero" or
        b:getUserData().properties.Ground == true and a:getUserData().properties.tag == "Hero") then
        local player
        if a:getUserData().properties.tag == "Hero" then
            player = a:getUserData().properties
        elseif b:getUserData().properties.tag == "Hero" then
            player = b:getUserData().properties
        end
        player.jumpCount = 2
    end
    
    -- Trata colisão do tiro do player
    if (a:getUserData().properties.tag == "PlayerShot" or b:getUserData().properties.tag == "PlayerShot") then
        local shot
        local other
        if a:getUserData().properties.tag == "PlayerShot" then
          shot = a:getUserData().properties
          other = b:getUserData().properties
        elseif b:getUserData().properties.tag == "PlayerShot" then
          shot = b:getUserData().properties
          other = a:getUserData().properties
        end

        if other.tag ~= "Hero" and other.tag ~= "Coin" then
            shot.remove()        
        end
        if other.tag == "Enemy" then
            other.remove()
        end          
    end
    
    -- Trata colisão do tiro do inimigo
    if (a:getUserData().properties.tag == "EnemyShot" or b:getUserData().properties.tag == "EnemyShot") then
        local shot
        local other
        if a:getUserData().properties.tag == "EnemyShot" then
          shot = a:getUserData().properties
          other = b:getUserData().properties
        elseif b:getUserData().properties.tag == "EnemyShot" then
          shot = b:getUserData().properties
          other = a:getUserData().properties
        end

        if other.tag ~= "Enemy" and other.tag ~= "Coin" then
            shot.remove()        
        end
        if other.tag == "Hero" then
          hero.damage(10)
        end
    end
    
    -- Trata colisão do player com moedas
    if (a:getUserData().properties.tag == "Coin" and b:getUserData().properties.tag == "Hero" or
        b:getUserData().properties.tag == "Coin" and a:getUserData().properties.tag == "Hero") then
        local player
        local coin
        if a:getUserData().properties.tag == "Hero" then
            player = a:getUserData().properties
            coin = b:getUserData().properties
        elseif b:getUserData().properties.tag == "Hero" then
            player = b:getUserData().properties
            coin = a:getUserData().properties
        end
        player.coins = player.coins + 1
        coin.remove()
    end

end

function endContact(a, b, coll)
    
end

function preSolve(a, b, coll)
    
end

function postSolve(a, b, coll, normalimpulse, tangentimpulse)
    
end

return CollisionManager