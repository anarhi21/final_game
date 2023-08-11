local reds = {} -- the CO2 gasses
local greens = {} -- the solar panels

math.randomseed(os.time())

local spawnInterval_red = 3 -- interval at which each new CO2 gas sprite appears
local spawnInterval_green = 20 -- interval at which each new solar panel sprite appears
local timeElapsed_red = 0
local timeElapsed_green = 0
local total_points = 0

local game_running = false
local game_finished_lost = false
local game_finished_won = false

--------------------------------- LOVE LOAD ---------------------------------
function love.load()
    love.window.setTitle("Avoid global warming!")
    love.window.setMode(1600, 900, {resizable=true, fullscreen = true, fullscreentype = 'desktop', minwidth=800, minheight=600})
    world = love.physics.newWorld(0, 0, true)
    
    me = {}
        me.lives = 3
        me.x = love.graphics.getWidth() / 2
        me.y = love.graphics.getHeight() / 2
        me.body = love.physics.newBody(world, me.x, me.y, 'dynamic')
        me.radius = 25
        me.speed = 5
        me.shape = love.physics.newCircleShape(me.radius)
        me.sprite = love.graphics.newImage('sprites/earth.png')
end

--------------------------------- LOVE UPDATE ---------------------------------
function love.update(dt)
    if total_points > 100 then
        game_running = false
        game_finished_won = true
    end
    if game_running == true then
        love.mouse.setVisible(false)
        world:update(dt)
        movement()
        border()
        reflect()
        collision()
        total_points = total_points + dt       
        timeElapsed_red = timeElapsed_red + dt
        timeElapsed_green = timeElapsed_green + dt
        if timeElapsed_red >= spawnInterval_red then
            spawnred()
            timeElapsed_red = timeElapsed_red - spawnInterval_red
        elseif timeElapsed_green >= spawnInterval_green then
            spawngreen()
            timeElapsed_green = timeElapsed_green - spawnInterval_green
        end   
    end
end

--------------------------------- LOVE DRAW ---------------------------------
function love.draw()
    love.graphics.printf('Years: ' .. math.floor(total_points + 0.5), love.graphics.newFont(16), 50, 30, 100)
    love.graphics.printf('Lives: ' .. me.lives, love.graphics.newFont(16), love.graphics.getWidth() - 100, 30, 100)

    if game_running == true then
        for i, red in ipairs(reds) do
            love.graphics.draw(red.sprite, red.body:getX(), red.body:getY())
        end
        for i, green in ipairs(greens) do
            love.graphics.draw(green.sprite, green.body:getX(), green.body:getY())
        end
        love.graphics.draw(me.sprite, me.x, me.y)
    else
        love.graphics.setColor(0.1, 0.8, 0.4)
        love.graphics.printf('GLOBAL WARMING - THE GAME.', love.graphics.newFont(26), love.graphics.getWidth()*0.25, love.graphics.getHeight()*0.25 , 800, 'center')
        love.graphics.printf('The year is 2023. The world is at a perilous stage where global warming is increasing. Survive as long as you can by avoiding CO2 gasses and gathering solar panels.', love.graphics.newFont(26), love.graphics.getWidth()*0.25, love.graphics.getHeight()*0.3 , 800, 'center')
        love.graphics.printf('Game instructions: use the W, S, A, D keys to move around.', love.graphics.newFont(26), love.graphics.getWidth()*0.25, love.graphics.getHeight()*0.3 + 150, 800, 'center')
        love.graphics.setColor(0.8, 0.8, 0)
        love.graphics.printf('Press Space to start the game!', love.graphics.newFont(32), love.graphics.getWidth()*0.34, love.graphics.getHeight()*0.3 + 300, 500, 'center')
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf('Press Esc to quit the game!', love.graphics.newFont(22), love.graphics.getWidth()*0.33, love.graphics.getHeight()*0.3 + 550, 500, 'center')
        love.graphics.printf('Developed by Reinis Udris', love.graphics.newFont(16), love.graphics.getWidth()*0.7, love.graphics.getHeight()*0.9, 500, 'center')
    end
    
    if game_finished_lost == true then
        love.graphics.setColor(0.7, 0.1, 0)
        love.graphics.printf('The world has perished. Better luck next time!', love.graphics.newFont(26), love.graphics.getWidth()*0.28, love.graphics.getHeight()*0.1, 700, 'center')
        love.graphics.setColor(1, 1, 1)
    elseif game_finished_won == true then
        love.graphics.setColor(0.1, 0.8, 0.4)
        love.graphics.printf('You managed to survive the next 100 years! Congratulations!', love.graphics.newFont(26), love.graphics.getWidth()*0.28, love.graphics.getHeight()*0.1, 700, 'center')
        love.graphics.setColor(1, 1, 1)
    end 
end

------------------- SUPPORTING FUNCTIONS ------------------------------
-- Spawn CO2
function spawnred()
    local x, y = math.random(50, love.graphics.getWidth() - 50), math.random(50, love.graphics.getHeight() - 50)
    red = {}
        red.body = love.physics.newBody(world, x, y, 'dynamic')
        red.radius = 20
        local initialX = math.random(-200, 200)
        local initialY = math.random(-200, 200)
        local dice = math.random(1, 4)
        if dice == 1 then
            red.body:setLinearVelocity(initialX, initialY)
        elseif dice == 2 then
            red.body:setLinearVelocity(initialX*2, initialY*2)
        elseif dice == 3 then
            red.body:setLinearVelocity(initialX*4, initialY*4)
        else
            red.body:setLinearVelocity(initialX*6, initialY*6)
        end
        red.shape = love.physics.newCircleShape(red.radius)
        red.fixture = love.physics.newFixture(red.body, red.shape)
        red.fixture:setRestitution(1)
        red.sprite = love.graphics.newImage('sprites/co2.jpg')
    table.insert(reds, red)
end

-- Spawn solar panels
function spawngreen()
    local x, y = math.random(50, love.graphics.getWidth() - 50), math.random(50, love.graphics.getHeight() - 50)
    green = {}
        green.body = love.physics.newBody(world, x, y, 'dynamic')
        green.radius = 20
        green.body:setLinearVelocity(math.random(-200, 200), math.random(-200, 200))
        green.shape = love.physics.newCircleShape(green.radius)
        green.fixture = love.physics.newFixture(green.body, green.shape)
        green.fixture:setRestitution(1)
        green.sprite = love.graphics.newImage('sprites/solar.jpg')
    table.insert(greens, green)
end

-- Enable collisions with walls
function reflect()
    for i, red in ipairs(reds) do
        local x, y = red.body:getPosition()
        local vx, vy = red.body:getLinearVelocity()
        if y < red.radius or y > love.graphics.getHeight() - red.radius * 2 then
            red.body:setLinearVelocity(vx, -vy)
        elseif x < red.radius or x > love.graphics.getWidth() - red.radius * 2 then
            red.body:setLinearVelocity(-vx, vy)
        end
    end
    for i, green in ipairs(greens) do
        local x, y = green.body:getPosition()
        local vx, vy = green.body:getLinearVelocity()
        if y < green.radius or y > love.graphics.getHeight() - green.radius * 2 then
            green.body:setLinearVelocity(vx, -vy)
        elseif x < green.radius or x > love.graphics.getWidth() - green.radius * 2 then
            green.body:setLinearVelocity(-vx, vy)
        end
    end
end

-- Check for collision with player
function collision()
    for i, red in ipairs(reds) do
        local x, y = red.body:getPosition()
        if math.sqrt((me.x - x) ^ 2 + (me.y - y) ^ 2) <= (me.radius + red.radius) then
            table.remove(reds, i)
            me.lives = me.lives - 1
            if me.lives == 0 then
                game_running = false
                game_finished_lost = true
            end
        end
    end
    for i, green in ipairs(greens) do
        local x, y = green.body:getPosition()
        if math.sqrt((me.x - x) ^ 2 + (me.y - y) ^ 2) <= (me.radius + red.radius) then
            table.remove(greens, i)
            me.lives = me.lives + 1
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
    if me.x < 0 then
        me.x = 1
    elseif me.x > love.graphics.getWidth() -50 then
        me.x = love.graphics.getWidth() - 50
    end
    
    if me.y < 0 then
        me.y = 1
    elseif me.y > love.graphics.getHeight() -50 then
        me.y = love.graphics.getHeight() - 50
    end
end

-- Added 'space' key for starting the game, 'esc' for quitting it
function love.keypressed(key, unicode)
	if key == "space" then
        if game_running ~= true then
            game_running = true
            me.lives = 3
            timeElapsed = 0
            total_points = 0
            me.x = love.graphics.getWidth() / 2
            me.y = love.graphics.getHeight() / 2
            reds = {}
            greens = {}
            timeElapsed_red = 0
            timeElapsed_green = 0
            game_finished_lost = false
            game_finished_won = false
        end
    elseif key == "escape" then
        love.event.quit()
	end
end