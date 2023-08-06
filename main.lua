

local reds = {}

math.randomseed(os.time())

local spawnInterval = 3
local timeElapsed = 0

function love.load()
    world = love.physics.newWorld(0, 0, true)

    me = {}
        me.lives = 3
        me.x = 400
        me.y = 300
        me.body = love.physics.newBody(world, me.x, me.y, 'dynamic')
        me.radius = 10
        me.speed = 3
        me.shape = love.physics.newCircleShape(me.radius)
       
end

function love.update(dt)
    world:update(dt)
    movement()
    border()
    reflect()
    collision()
    
    
    timeElapsed = timeElapsed + dt
    if timeElapsed >= spawnInterval then
        spawnred()
        timeElapsed = timeElapsed - spawnInterval
    end

end

function spawnred()
    local x, y = math.random(15, 785), math.random(15, 585)
    red = {}
        red.body = love.physics.newBody(world, x, y, 'dynamic')
        red.radius = 10
        red.body:setLinearVelocity(math.random(-200, 200), math.random(-200, 200))
        red.shape = love.physics.newCircleShape(red.radius)
    table.insert(reds, red)
    
end


-- Enable collisions with walls
function reflect()
    for i, red in ipairs(reds) do
        local x, y = red.body:getPosition()
        local vx, vy = red.body:getLinearVelocity()
        local radius = red.radius
        if y < radius or y > love.graphics.getHeight() - radius then
            red.body:setLinearVelocity(vx, -vy)
        elseif x < radius or x > love.graphics.getWidth() - radius then
            red.body:setLinearVelocity(-vx, vy)
        end
    end
end




-- Check for collision with player
function collision()
    for i, red in ipairs(reds) do
        local x, y = red.body:getPosition()
        if math.sqrt((me.x - x) ^ 2 + (me.y - y) ^ 2) <= me.radius * 2 then
            table.remove(reds, i)
            me.lives = me.lives - 1
            if me.lives == 0 then
                me.lives = 3
            end   
        end
    end
end

-- Enabling movement for the player
function movement()
    if love.keyboard.isDown('w') then
        me.y = me.y - me.speed
    end
    
    if love.keyboard.isDown('s') then
        me.y = me.y + me.speed
    end
    
    if love.keyboard.isDown('a') then
        me.x = me.x - me.speed
    end

    if love.keyboard.isDown('d') then
        me.x = me.x + me.speed
    end
end

-- Border to restrict player's movement so it can't leave the screen
function border()
    if me.y < 0 then
        me.y = 3
    elseif me.y > 600 then
        me.y = 600
    end

    if me.x < 0 then
        me.x = 3
    elseif me.x > 800 then
        me.x = 800
    end
end


function love.draw()
    --love.graphics.printf('Pos.x: ' .. me.x, love.graphics.newFont(16), 50, 30, 100)
    --love.graphics.printf('Pos.y: ' .. me.y, love.graphics.newFont(16), 50, 50, 100)
    love.graphics.printf('Lives: ' .. me.lives, love.graphics.newFont(16), 700, 30, 100)
    love.graphics.circle('fill', me.x, me.y, me.radius)
    for i, red in ipairs(reds) do
        love.graphics.circle('fill', red.body:getX(), red.body:getY(), red.radius)
    end

end

