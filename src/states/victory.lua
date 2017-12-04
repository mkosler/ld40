local Victory = {}

function Victory:init()
    self.buttons = {
        ['return'] = {
            bbox = { 274, 636, 747, 696 },
            callback = function ()
                Gamestate.switch(STATES.TITLE)
            end,
        },
    }
end

function Victory:enter(prev, results, score)
    love.mouse.setCursor()
    self.prev = prev
    self.results = results
    self.score = score
    self.showScore = false
    self.max = 0
    self.dt = (610 - (10 * 37)) / 11

    self.timer = Timer.new()

    self.timer:every(1, function ()
        self.max = self.max + 1
        if self.max >= #self.results then
            self.showScore = true
        end
    end, #self.results)
end

function Victory:resume()
end

function Victory:leave()
    self.timer:clear()
    ASSETS['loop-sfx']:stop()
end

function Victory:update(dt)
    self.timer:update(dt)

    self.hover = nil
    for k,v in pairs(self.buttons) do
        if Utils.hover(love.mouse.getX(), love.mouse.getY(), unpack(v.bbox)) then
            self.hover = k
        end
    end
end

function Victory:draw()
    self.prev:draw()

    love.graphics.push('all')
    love.graphics.translate(love.graphics.getWidth() / 2 - ASSETS['paycheck']:getWidth() / 2, love.graphics.getHeight() / 2 - ASSETS['paycheck']:getHeight() / 2)
    love.graphics.draw(ASSETS['paycheck'])
    for i = 1, self.max do
        local j = (i - 1) % 5
        love.graphics.push('all')
        if i <= 5 then
            love.graphics.translate(100, 134 + (j * 37) + ((j + 1) * self.dt))
        else
            love.graphics.translate(400, 134 + (j * 37) + ((j + 1) * self.dt))
        end
        if self.results[i] > 0 then
            love.graphics.draw(ASSETS['success'], 0, 0, 0, 0.5)
        else
            love.graphics.draw(ASSETS['failure'], 0, 0, 0, 0.5)
        end
        love.graphics.setColor(0, 0, 0)
        love.graphics.print(string.format('+$%04.2f', self.results[i]), (ASSETS['success']:getWidth() / 2) + 20, 10)
        love.graphics.pop()
    end
    if self.showScore then
        love.graphics.setColor(0, 0, 0)
        love.graphics.setFont(ASSETS['font-30'])
        love.graphics.print(string.format('$%04.2f', self.score), 490, 510)
    end
    love.graphics.pop()

    if self.hover then
        love.graphics.draw(ASSETS[self.hover..'-blur'], self.buttons[self.hover].bbox[1], self.buttons[self.hover].bbox[2])
    end
end

function Victory:keypressed(key)
end

function Victory:keyreleased(key)
end

function Victory:mousepressed(x, y, btn)
    for k,v in pairs(self.buttons) do
        if Utils.hover(x, y, unpack(v.bbox)) then
            v.callback()
        end
    end
end

function Victory:mousereleased(x, y, btn)
end

return Victory