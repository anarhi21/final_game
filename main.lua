local button = require("libraries.simplebutton")

local reds = {}

math.randomseed(os.time())

local spawnInterval = 3
local timeElapsed = 0
local total_points = 0

local main_menu = true
local game_running = false
local pause = false
local game_finished = false

function love.load()
    love.window.setTitle("Avoid global warming!")
    love.window.setMode(1600, 900, {resizable=true, fullscreen = false, fullscreentype = 'desktop', minwidth=800, minheight=600})
    world = love.physics.newWorld(0, 0, true)
    --earth = love.graphics.newImage('sprites/earth.png')
    start_game = button.new("Start Game", love.graphics.getWidth()/2 - 50, love.graphics.getHeight()/2 - 20, 100, 50)
    --start_game.font_size = 36
    --start_game.text:setFont(start_game.font, start_game.font_size)
    --start_game:setLabel("Start Game", 36)
    start_game.onClick = startNewGame
    
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

function love.update(dt)
    if game_running == true then
        love.mouse.setVisible(false)
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


---------------- LOVE DRAW ---------------------------------
function love.draw()
    love.graphics.printf('Years: ' .. math.floor(total_points + 0.5), love.graphics.newFont(16), 50, 30, 100)
    love.graphics.printf('Lives: ' .. me.lives, love.graphics.newFont(16), love.graphics.getWidth() - 100, 30, 100)

    if game_running == true then
        --love.graphics.setColor(1, 1, 1)
        --love.graphics.circle('fill', me.x, me.y, me.radius)
        for i, red in ipairs(reds) do
            --love.graphics.circle('fill', red.body:getX(), red.body:getY(), red.radius)
            
            love.graphics.draw(red.sprite, red.body:getX(), red.body:getY())
        end
        love.graphics.draw(me.sprite, me.x, me.y)
    end
    
    if game_finished == true then
        love.graphics.printf('The world has perished. Better luck next time!', love.graphics.newFont(26), love.graphics.getWidth()/2-200, 50, 400, 'center')
    end

    
    if main_menu == true then
        love.graphics.printf('Years: ' .. math.floor(total_points + 0.5), love.graphics.newFont(16), 50, 30, 100)
        love.graphics.printf('Lives: ' .. me.lives, love.graphics.newFont(16), love.graphics.getWidth() - 100, 30, 100)
        button.draw(start_game)
    end

end

------------------- SUPPORTING FUNCTIONS ------------------------------
-- Spawn baddies
function spawnred()
    local x, y = math.random(50, love.graphics.getWidth() - 50), math.random(50, love.graphics.getHeight() - 50)
    red = {}
        red.body = love.physics.newBody(world, x, y, 'dynamic')
        red.radius = 20
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
        --local radius = red.radius
        if y < 0 or y > love.graphics.getHeight() - red.radius * 2 then
            red.body:setLinearVelocity(vx, -vy)
        elseif x < 0 or x > love.graphics.getWidth() - red.radius * 2 then
            red.body:setLinearVelocity(-vx, vy)
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
                main_menu = true
                game_finished = true
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
    if me.x < 0 then
        me.x = 15
    elseif me.x > love.graphics.getWidth() then
        me.x = love.graphics.getWidth() - 15
    end
    
    if me.y < 0 then
        me.y = 15
    elseif me.y > love.graphics.getHeight() then
        me.y = love.graphics.getHeight() - 15
    end
end

-- Function for pressing buttons and keys
function startNewGame()
    game_running = true
    main_menu = false
end

function love.keypressed(key, unicode)
	if key == "escape" then
		love.event.quit()
	end
end

function love.mousepressed( x, y, msbutton, istouch, presses )
    button.mousepressed(x,y,msbutton)
end

function love.mousereleased( x, y, msbutton, istouch, presses )
    button.mousereleased(x,y,msbutton)
end
