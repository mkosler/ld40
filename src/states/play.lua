local Play = {}

function Play:init()
end

function Play:enter(prev, order, tutorial)
    love.mouse.setCursor()
    self.tutorial = tutorial or false

    self.time = 0
    self.timeLabel = Label(ASSETS['font-30'])
    self.timeLabel:setf(string.format('%05.2f', 0), 100)
    self.timeLabel.pos = Vector(10, love.graphics.getHeight() - self.timeLabel:getHeight() - 10)

    self.score = 0
    self.scoreLabel = Label(ASSETS['font-30'])
    self.scoreLabel:setf(string.format('$%05.2f', 0), 100)
    self.scoreLabel.pos = Vector(love.graphics.getWidth() - self.scoreLabel:getWidth() - 10, love.graphics.getHeight() - self.scoreLabel:getHeight() - 10)

    self.prev = prev
    self.selected = nil
    self.order = order
    self.start = false

    self.particles = nil

    local n = #self.order.spices
    local dx = (love.graphics.getWidth() - (n * ASSETS['red-spice']:getWidth())) / (n + 1)

    for i,v in ipairs(self.order.spices) do
        local j = i - 1
        v.pos.x = (j * ASSETS['red-spice']:getWidth()) + ((j + 1) * dx)
        v.pos.y = love.graphics.getHeight() - ASSETS['red-spice']:getHeight() - 50
    end

    self.order.bowl.pos.x = love.graphics.getWidth() / 2 - ASSETS['soup']:getWidth() / 2
    self.order.bowl.pos.y = love.graphics.getHeight() / 2 - ASSETS['soup']:getHeight() / 2 - 100

    self.label = nil

    Timer.script(function (wait)
        self.label = Label(ASSETS['font-30-bold'])
        self.label:setf('Ready...', 120)
        self.label.pos = Vector(love.graphics.getWidth() / 2 - self.label:getWidth() / 2, love.graphics.getHeight() / 2 - self.label:getHeight() / 2)
        wait(1)
        self.label:setf('Set...', 120)
        self.label.pos = Vector(love.graphics.getWidth() / 2 - self.label:getWidth() / 2, love.graphics.getHeight() / 2 - self.label:getHeight() / 2)
        wait(1)
        self.label:setf('Go!', 120)
        self.label.pos = Vector(love.graphics.getWidth() / 2 - self.label:getWidth() / 2, love.graphics.getHeight() / 2 - self.label:getHeight() / 2)
        wait(1)
        self.start = true
        if self.tutorial then
            Gamestate.push(STATES.TUTORIAL)
        end
    end)
end

function Play:resume(from)
    if from == STATES.TUTORIAL then
        Gamestate.pop(false, true)
    end
end

function Play:leave()
    if self.particles then self.particles:stop() end
end

function Play:update(dt)
    if self.start then
        self.time = self.time + dt
        self.timeLabel:setf(string.format('%05.2f', self.time), 100)

        self.order.bowl:decay(dt)

        if self.particles then self.particles:update(dt) end

        if self.selected then
            if love.mouse.isDown(1) then
                if self.particles then
                    if not self.particles:isActive() then self.particles:start() end
                    -- self.particles:setPosition(love.mouse.getX(), love.mouse.getY())
                end

                if Utils.hover(love.mouse.getX(), love.mouse.getY(), self.order.bowl:bbox()) then
                    self.order.bowl:modify(self.selected, 1)
                    if self.tutorial then Signal.emit('left-click') end
                end
            else
                self.particles:pause()
            end
        end
    end
end

function Play:draw()
    self.prev:draw()

    love.graphics.push('all')
    self.order.bowl:draw()
    Utils.foreach(self.order.spices, 'draw')
    if self.particles then love.graphics.draw(self.particles, love.mouse.getX(), love.mouse.getY()) end
    self.timeLabel:draw()
    self.scoreLabel:draw()

    if not self.start then
        self.label:draw()
    end

    -- love.graphics.setColor(0, 255, 0)
    -- love.graphics.line(love.graphics.getWidth() / 2, 0, love.graphics.getWidth() / 2, love.graphics.getHeight())
    -- love.graphics.line(0, love.graphics.getHeight() / 2, love.graphics.getWidth(), love.graphics.getHeight() / 2)

    love.graphics.pop()
end

function Play:keypressed(key)
    if not self.start then return end

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
            if Utils.hover(x, y, v:bbox()) then
                self.selected = v:select()
                if self.particles and self.particles:isActive() then
                    self.particles:stop()
                end
                self.particles = ASSETS[self.selected..'-particle']
                self.particles:reset()
                love.mouse.setCursor(ASSETS[self.selected..'-cursor'])
                if self.tutorial then Signal.emit('right-click', self.selected) end
            end
        end
    end
end

function Play:mousereleased(x, y, btn)
end

return Play