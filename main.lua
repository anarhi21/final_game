local reds = {}

math.randomseed(os.time())

local spawnInterval = 1
local timeElapsed = 0
local total_points = 0

local game_running = true

function love.load()
    love.window.setTitle("Avoid global warming!")
    world = love.physics.newWorld(0, 0, true)
    me = {}
        me.lives = 3
        me.x = 400
        me.y = 300
        me.body = love.physics.newBody(world, me.x, me.y, 'dynamic')
        me.radius = 10
        me.speed = 3
        me.shape = love.physics.newCircleShape(me.radius)
        me.sprite = love.graphics.newImage('sprites/earth.png')
       
end

function love.update(dt)
    if game_running == true then
        world:update(dt)
        movement()
        border()
        reflect()
        collision()
        
        total_points = total_points + dt
        
        timeElapsed = timeElapsed + dt
        if timeElapsed >= spawnInterval then
            spawnred()
            timeElapsed = timeElapsed - spawnInterval
        end
    end
end

-- Spawn baddies
function spawnred()
    local x, y = math.random(15, 785), math.random(15, 585)
    red = {}
        red.body = love.physics.newBody(world, x, y, 'dynamic')
        red.radius = 10
        red.body:setLinearVelocity(math.random(-200, 200), math.random(-200, 200))
        red.shape = love.physics.newCircleShape(red.radius)
        red.fixture = love.physics.newFixture(red.body, red.shape)
        red.fixture:setRestitution(1)
        red.sprite = love.graphics.newImage('sprites/co2.jpg')
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
                game_running = false
                --me.lives = 3
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
    if game_running == false then
        love.graphics.print('The world has perished. Better luck next time!', love.graphics.newFont(26), 100, 300, 0)
    end
    love.graphics.printf('Points: ' .. math.floor(total_points + 0.5), love.graphics.newFont(16), 50, 30, 100)
    love.graphics.printf('Lives: ' .. me.lives, love.graphics.newFont(16), 700, 30, 100)
    if game_running == true then
        love.graphics.draw(me.sprite, me.x, me.y)
        --love.graphics.circle('fill', me.x, me.y, me.radius)
        for i, red in ipairs(reds) do
            --love.graphics.circle('fill', red.body:getX(), red.body:getY(), red.radius)
            love.graphics.draw(red.sprite, red.body:getX(), red.body:getY())
        end
    end
end

