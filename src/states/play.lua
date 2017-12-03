local Play = {}

local function hover(x, y, l, t, r, b)
    return l <= x and x <= r and t <= y and y <= b
end

function Play:init()
end

function Play:enter(prev, order)
    self.prev = prev
    self.selected = nil
    self.order = order

    local n = #self.order.spices
    local dx = (love.graphics.getWidth() - (n * ASSETS['red-spice']:getWidth())) / (n + 1)

    for i,v in ipairs(self.order.spices) do
        local j = i - 1
        v.pos.x = (j * ASSETS['red-spice']:getWidth()) + ((j + 1) * dx)
        v.pos.y = love.graphics.getHeight() - ASSETS['red-spice']:getHeight() - 50
    end

    self.order.bowl.pos.x = love.graphics.getWidth() / 2 - ASSETS['soup']:getWidth() / 2
    self.order.bowl.pos.y = love.graphics.getHeight() / 2 - ASSETS['soup']:getHeight() / 2 - 100
end

function Play:resume()
end

function Play:leave()
end

function Play:update(dt)
    self.order.bowl:decay(dt)

    if self.selected and love.mouse.isDown(1) then
        if hover(love.mouse.getX(), love.mouse.getY(), self.order.bowl:bbox()) then
            self.order.bowl:modify(self.selected, 1)
        end
    end
end

function Play:draw()
    self.prev:draw()

    love.graphics.push('all')
    love.graphics.setColor(255, 255, 255)
    if self.selected then love.graphics.print(self.selected, 10, 10) end
    self.order.bowl:draw()
    Utils.foreach(self.order.spices, 'draw')
    love.graphics.pop()
end

function Play:keypressed(key)
    if key == 'space' then
        if self.order.bowl:isBalanced() then
            Gamestate.pop(true)
        else
            Gamestate.pop(false)
        end
    end
end

function Play:keyreleased(key)
end

function Play:mousepressed(x, y, btn)
    if btn == 2 then
        for k,v in pairs(self.order.spices) do
            if hover(x, y, v:bbox()) then
                self.selected = v:select()
            end
        end
    end
end

function Play:mousereleased(x, y, btn)
end

return Play