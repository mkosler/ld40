local Title = {}

function Title:init()
    self.buttons = {
        play = {
            bbox = { 120, 301, 593, 361 },
            callback = function ()
                Gamestate.switch(STATES.PLAY, 10)
            end,
        },
        tutorial = {
            bbox = { 120, 427, 593, 487 },
            callback = function ()
                Gamestate.switch(STATES.PLAY, 1, true)
            end,
        },
        quit = {
            bbox = { 120, 553, 593, 613 },
            callback = function ()
                love.event.quit()
            end,
        },
    }
end

function Title:enter(prev)
    love.mouse.setCursor()
    love.graphics.setBackgroundColor(211, 188, 141)
end

function Title:resume()
end

function Title:leave()
end

function Title:update(dt)
    self.hover = nil
    for k,v in pairs(self.buttons) do
        if Utils.hover(love.mouse.getX(), love.mouse.getY(), unpack(v.bbox)) then
            self.hover = k
        end
    end
end

function Title:draw()
    love.graphics.draw(ASSETS['title-screen'])

    -- love.graphics.push('all')
    -- love.graphics.setColor(255, 0, 0)
    -- for k,v in pairs(self.buttons) do
    --     love.graphics.rectangle('line', v.bbox[1], v.bbox[2], v.bbox[3] - v.bbox[1], v.bbox[4] - v.bbox[2])
    -- end
    -- love.graphics.pop()

    if self.hover then
        love.graphics.draw(ASSETS[self.hover..'-blur'], self.buttons[self.hover].bbox[1], self.buttons[self.hover].bbox[2])
    end
end

function Title:keypressed(key)
end

function Title:keyreleased(key)
end

function Title:mousepressed(x, y, btn)
    for k,v in pairs(self.buttons) do
        if Utils.hover(x, y, unpack(v.bbox)) then
            v.callback()
        end
    end
end

function Title:mousereleased(x, y, btn)
end

return Title