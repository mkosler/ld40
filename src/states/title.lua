local Title = {}

function Title:init()
    self.buttons = {
        play = {
            bbox = { 120, 300, 593, 360 },
            callback = function ()
                Gamestate.switch(STATES.PREPLAY, 3)
            end,
        },
        tutorial = {
            bbox = { 120, 426, 593, 486 },
            callback = function ()
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

    if self.hover then
        love.graphics.draw(ASSETS[self.hover..'-blur'], self.buttons[self.hover].bbox[1] - 3, self.buttons[self.hover].bbox[2] - 4)
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