local Play = {}

function Play:init()
end

function Play:enter(prev)
end

function Play:resume()
end

function Play:leave()
end

function Play:update(dt)
end

function Play:draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.rectangle('fill', love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 100, 100)
end

function Play:keypressed(key)
end

function Play:keyreleased(key)
end

function Play:mousepressed(x, y, btn)
end

function Play:mousereleased(x, y, btn)
end

return Play