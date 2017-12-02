local Bucket = require 'src.bucket'

local Play = {}

function Play:init()
end

function Play:enter(prev)
    self.bucket = Bucket({200, 200, 200})
end

function Play:resume()
end

function Play:leave()
end

function Play:update(dt)
end

function Play:draw()
    self.bucket:draw(Vector(100, 100), 50)
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