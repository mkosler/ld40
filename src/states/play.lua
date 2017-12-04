local Play = {}

function Play:init()
end

function Play:emitFade()
    if #self.textFades == 0 then
        self.fadingText = nil
        return
    end

    local n = table.remove(self.textFades, 1)
    Timer.tween(1, n.color, { n.color[1], n.color[2], n.color[3], 0 })
    Timer.tween(1, n.pos, Vector(n.pos.x, n.pos.y - 100))
    self.fadingText = n
end

function Play:enter(prev, count, tutorial)
    love.mouse.setCursor()
    ASSETS['loop-sfx']:rewind()
    ASSETS['loop-sfx']:play()
    love.graphics.setBackgroundColor(116, 164, 242)
    self.tutorial = tutorial or false

    self.time = 0
    self.timeLabel = Label(ASSETS['font-30'])
    self.timeLabel:setf(string.format('%05.2f', self.time), 100)
    self.timeLabel.pos = Vector(10, love.graphics.getHeight() - self.timeLabel:getHeight() - 10)

    self.score = 0
    self.textFades = {}
    self.scoreLabel = Label(ASSETS['font-30'])
    self.scoreLabel:setf(string.format('$%05.2f', self.score), 100)
    self.scoreLabel.pos = Vector(love.graphics.getWidth() - self.scoreLabel:getWidth() - 10, love.graphics.getHeight() - self.scoreLabel:getHeight() - 10)
    self.chain = 1
    self.additions = {}

    Signal.register('nextOrder', function (result)
        local no = self.table:getNextOrder()

        if not no then
            Gamestate.switch(STATES.VICTORY, self.additions, self.score)
            return
        end

        self.time = 0
        self.order = no

        local n = #self.order.spices
        local dx = (love.graphics.getWidth() - (n * ASSETS['red-spice']:getWidth())) / (n + 1)

        for i,v in ipairs(self.order.spices) do
            local j = i - 1
            v.pos.x = (j * ASSETS['red-spice']:getWidth()) + ((j + 1) * dx)
            v.pos.y = love.graphics.getHeight() - ASSETS['red-spice']:getHeight() - 50
        end

        self.order.bowl.pos.x = love.graphics.getWidth() / 2 - ASSETS['soup']:getWidth() / 2
        self.order.bowl.pos.y = love.graphics.getHeight() / 2 - ASSETS['soup']:getHeight() / 2 - 100
    end)

    self.selected = nil
    self.count = count
    self.table = Order(count)
    self.dt = (love.graphics.getWidth() - (10 * ASSETS['soup-small']:getWidth())) / 11
    self.results = {}
    Signal.emit('nextOrder')

    self.start = false

    self.particles = nil

    self.scoreSignal = Signal.register('score', function ()
        ASSETS['success-sfx']:play()
        local addition = self.chain * 5 / (self.time / 10)
        table.insert(self.additions, addition)
        table.insert(self.textFades, {
            text = string.format('+$%05.2f', addition),
            color = { 0, 255, 0, 255 },
            pos = self.scoreLabel.pos:clone()
        })
        if self.chain > 1 then
            table.insert(self.textFades, {
                text = string.format('x%d', self.chain),
                color = { 0, 255, 0, 255 },
                pos = self.scoreLabel.pos:clone()
            })
        end
        self.score = self.score + addition
        self.chain = self.chain + 1
        self.scoreLabel:setf(string.format('$%05.2f', self.score), 100)
    end)

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

    Timer.every(0.5, function() self:emitFade() end)
end

function Play:resume(from)
    if from == STATES.TUTORIAL then
        Gamestate.switch(STATES.TITLE)
    end
end

function Play:leave()
    if self.particles then self.particles:stop() end
    Signal.clear('score')
    Signal.clear('nextOrder')
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
    for i = 1, self.count do
        love.graphics.push()
        love.graphics.translate((ASSETS['soup-small']:getWidth() * (i - 1)) + (self.dt * i), 20)
        love.graphics.draw(ASSETS['soup-small'])
        if self.results[i] ~= nil then
            love.graphics.push()
            if self.results[i] then
                love.graphics.draw(
                    ASSETS['success'],
                    ASSETS['soup-small']:getWidth() / 2 - ASSETS['success']:getWidth() / 2,
                    ASSETS['soup-small']:getHeight() / 2 - ASSETS['success']:getHeight() / 2
                )
            else
                love.graphics.draw(
                    ASSETS['failure'],
                    ASSETS['soup-small']:getWidth() / 2 - ASSETS['failure']:getWidth() / 2,
                    ASSETS['soup-small']:getHeight() / 2 - ASSETS['failure']:getHeight() / 2
                )
            end
            love.graphics.pop()
        end
        love.graphics.pop()
    end

    love.graphics.push('all')
    self.order.bowl:draw()
    Utils.foreach(self.order.spices, 'draw')
    if self.particles then love.graphics.draw(self.particles, love.mouse.getX(), love.mouse.getY()) end
    self.timeLabel:draw()
    self.scoreLabel:draw()

    if self.fadingText then
        love.graphics.push('all')
        love.graphics.translate(self.fadingText.pos.x, self.fadingText.pos.y)
        love.graphics.setColor(self.fadingText.color)
        love.graphics.setFont(ASSETS['font-30-bold'])
        love.graphics.print(self.fadingText.text)
        love.graphics.pop()
    end

    if not self.start then
        self.label:draw()
    end
    love.graphics.pop()
end

function Play:keypressed(key)
    if not self.start then return end

    if key == 'space' then
        if self.order.bowl:isBalanced() then
            Signal.emit('score')
            table.insert(self.results, true)
            Signal.emit('nextOrder')
        else
            self.chain = 1
            table.insert(self.additions, 0)
            table.insert(self.results, false)
            ASSETS['failure-sfx']:play()
            Signal.emit('nextOrder')
        end
    end
end

function Play:keyreleased(key)
end

function Play:mousepressed(x, y, btn)
    if not self.start then return end

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