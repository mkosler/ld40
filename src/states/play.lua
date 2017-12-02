local Bucket = require 'src.bucket'
local Palette = require 'src.palette'

local function hoverCircle(x, y, cx, cy, r)
    return math.sqrt(((x - cx) * (x - cx)) + ((y - cy) * (y - cy))) <= r
end

local Play = {}

function Play:init()
end

function Play:enter(prev)
    self.bucket = Bucket({200, 200, 200}, Vector(100, 100), 50)
    self.palette = Palette({
        {
            color = 'red',
            capacity = 100,
            amount = 100
        },
        {
            color = 'green',
            capacity = 100,
            amount = 100
        },
        {
            color = 'blue',
            capacity = 100,
            amount = 100
        },
        {
            color = 'yellow',
            capacity = 100,
            amount = 100
        }
    }, Vector(400, 400))
end

function Play:resume()
end

function Play:leave()
end

function Play:update(dt)
    if love.mouse.isDown(1) and hoverCircle(love.mouse.getX(), love.mouse.getY(), self.bucket.pos.x, self.bucket.pos.y, self.bucket.radius) then
        -- self.currentColor = self.palette:use(1)
        self.bucket:modify(self.palette:use(1), 1)
    end
end

function Play:draw()
    self.bucket:draw()
    self.palette:draw()
    love.graphics.draw(ASSETS['tray'], 30, love.graphics.getHeight() - ASSETS['tray']:getHeight() + 15)
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