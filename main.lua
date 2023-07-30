
local me = {}

function love.load()
    me.x = 400
    me.y = 300
    me.radius = 10
    me.speed = 3
end

function love.update(dt)
   movement()
   border()

end

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
    love.graphics.circle('fill', me.x, me.y, me.radius)

end