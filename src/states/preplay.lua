local Preplay = {}

function Preplay:init()
end

function Preplay:enter(prev, count, tutorial)
    self.tutorial = tutorial or false

    love.graphics.setBackgroundColor(116, 164, 242)
    self.count = count
    self.results = {}
    self.order = Order(count)
    self.dt = (love.graphics.getWidth() - (10 * ASSETS['soup-small']:getWidth())) / 11

    Gamestate.push(STATES.PLAY, self.order:getNextOrder(), tutorial)
end

function Preplay:resume(one, result)
    table.insert(self.results, result)

    local nOrder = self.order:getNextOrder()

    if nOrder then Gamestate.push(STATES.PLAY, nOrder) end
end

function Preplay:leave()
end

function Preplay:update(dt)
end

function Preplay:draw()
    for i = 1, self.count do
        love.graphics.push()
        love.graphics.translate((ASSETS['soup-small']:getWidth() * (i - 1)) + (self.dt * i), 20)
        love.graphics.draw(ASSETS['soup-small'], 0, 0)
        if self.results[i] ~= nil then
            love.graphics.push()
            if self.results[i] then
                love.graphics.draw(
                    ASSETS['success'],
                    ASSETS['soup-small']:getWidth() / 2 - ASSETS['success']:getWidth() / 2,
                    ASSETS['soup-small']:getHeight() / 2 - ASSETS['success']:getHeight() / 2)
            else
                love.graphics.draw(
                    ASSETS['failure'],
                    ASSETS['soup-small']:getWidth() / 2 - ASSETS['failure']:getWidth() / 2,
                    ASSETS['soup-small']:getHeight() / 2 - ASSETS['failure']:getHeight() / 2)
            end
            love.graphics.pop()
        end
        love.graphics.pop()
    end
end

function Preplay:keypressed(key)
end

function Preplay:keyreleased(key)
end

function Preplay:mousepressed(x, y, btn)
end

function Preplay:mousereleased(x, y, btn)
end

return Preplay