local CollisionManager = {}

function CollisionManager.Init()
    -- Collision callbacks:
    world:setCallbacks(beginContact, endContact, preSolve, postSolve)
end

function beginContact(a, b, coll)  
    -- Trata reset do grounded para pulo
    if (a:getUserData().properties.Ground == true and b:getUserData().properties.tag == "Hero" or
        b:getUserData().properties.Ground == true and a:getUserData().properties.tag == "Hero") then
        hero.jumpCount = 2
    end

end

function endContact(a, b, coll)

end

function preSolve(a, b, coll)
    
end

function postSolve(a, b, coll, normalimpulse, tangentimpulse)

end

return CollisionManager