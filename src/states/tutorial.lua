local Tutorial = {}

function Tutorial:init()
    self.labels = {}
    self.actions = {}

    table.insert(self.labels, Label())
    self.labels[#self.labels]:setf("Welcome to your first day, chef! We're going to start you off just working the spice counter to get you into the swing of things.", 600)
    self.labels[#self.labels]:centerOnScreen()

    table.insert(self.labels, Label())
    self.labels[#self.labels]:setf("Our customers are very particular about their seasonings, so you need to get their order JUST RIGHT or they will not be happy at all.", 600)
    self.labels[#self.labels]:centerOnScreen()

    table.insert(self.labels, Label())
    self.labels[#self.labels]:setf("Here are your seasonings: red makes the soup extra spicy...", 250)
    self.labels[#self.labels].pos.x = 95
    self.labels[#self.labels].pos.y = 500

    table.insert(self.labels, Label())
    self.labels[#self.labels]:setf("Green makes the soup extra salty...", 250)
    self.labels[#self.labels].pos.x = 380
    self.labels[#self.labels].pos.y = 520

    table.insert(self.labels, Label())
    self.labels[#self.labels]:setf("And blue makes the soup more acidic!", 250)
    self.labels[#self.labels].pos.x = 690
    self.labels[#self.labels].pos.y = 520

    table.insert(self.labels, Label())
    self.labels[#self.labels]:setf("We tape the customer's desired seasoning levels to the bowl. Each seasoning has a small range that the customer will accept, marked with brackets on the order.", 600)
    self.labels[#self.labels]:center(love.graphics.getWidth(), love.graphics.getHeight() - 100)

    table.insert(self.labels, Label())
    self.labels[#self.labels]:setf("Select the spicy seasoning (red, left) by right-clicking on it.", 600)
    self.labels[#self.labels]:center(love.graphics.getWidth(), love.graphics.getHeight() - 100)
    self.actions[#self.labels] = function ()
        self.rightClickSignal = Signal.register('right-click', function (selected)
            if selected == 'red' then
                Signal.remove('right-click', self.rightClickSignal)
                Signal.emit('next')
            end
        end)
        self.pause = false
    end

    table.insert(self.labels, Label())
    self.labels[#self.labels]:setf("Good! Now, to add the seasoning to the soup, hover it over the bowl and left-click.", 600)
    self.labels[#self.labels]:center(love.graphics.getWidth(), 200)
    self.actions[#self.labels] = function ()
        self.leftClickSignal = Signal.register('left-click', function ()
            Signal.remove('left-click', self.leftClickSignal)
            Signal.emit('next')
        end)
        self.pause = false
    end

    table.insert(self.labels, Label())
    self.labels[#self.labels]:setf("Great! See how the indicator shifts as you add more seasoning to the soup? You need to keep adding until it is inside the acceptable range.", 600)
    self.labels[#self.labels]:center(love.graphics.getWidth(), 200)
    self.actions[#self.labels] = function ()
        self.redCheckTimer = self.timer:every(0.3, function ()
            if self.prev.order.bowl:isLevelBalanced('spicy') then
                self.timer:cancel(self.redCheckTimer)
                Signal.emit('next')
            end
        end)
        self.pause = false
    end

    table.insert(self.labels, Label())
    self.labels[#self.labels]:setf("Perfect. See if you can get the other seasonings to their desired level. Be careful, though! Seasoning levels decay over time, so watch all three!", 600)
    self.labels[#self.labels]:center(love.graphics.getWidth(), 200)
    self.actions[#self.labels] = function ()
        self.balancedTimer = self.timer:every(0.3, function ()
            if self.prev.order.bowl:isBalanced() then
                self.timer:cancel(self.balancedTimer)
                Signal.emit('next')
            end
        end)
        self.pause = false
    end

    table.insert(self.labels, Label())
    self.labels[#self.labels]:setf("HOLD IT! O.K., it's fully balanced. Press SPACE to send it to the customer!", 600)
    self.labels[#self.labels]:center(love.graphics.getWidth(), 200)
    self.actions[#self.labels] = function ()
        self.spaceSignal = Signal.register('space', function ()
            Signal.remove('space', self.spaceSignal)
            Signal.emit('next')
        end)
        self.pause = true
        self.buffer = true
    end

    table.insert(self.labels, Label())
    self.labels[#self.labels]:setf("Good job there, rookie! Now, we're about to open the doors, and once the customers are coming in, no one will be helping you along. If you send the soup out to the customer and it's not exactly how they like it, they won't leave a tip. I know, I know, that's a scummy thing to do, but it happens.", 600)
    self.labels[#self.labels]:centerOnScreen()
    self.actions[#self.labels] = function ()
        self.pause = true
        self.buffer = false
    end

    table.insert(self.labels, Label())
    self.labels[#self.labels]:setf("If you do get the order just right, you'll earn those tips. Customers value speed and accuracy, and the more orders in a row you serve correctly, the more you'll earn.", 600)
    self.labels[#self.labels]:centerOnScreen()

    table.insert(self.labels, Label())
    self.labels[#self.labels]:setf("Good luck!", 600)
    self.labels[#self.labels]:centerOnScreen()
end

function Tutorial:next()
    self.index = self.index + 1
    return self.labels[self.index], self.actions[self.index]
end

function Tutorial:enter(prev)
    self.prev = prev
    self.timer = Timer.new()
    self.nextSignal = Signal.register('next', function()
        local current, action = self:next()
        if not current then Gamestate.pop() end
        self.current = current
        if action then action() end
    end)
    self.index = 0
    self.on = false
    self.pause = true
    self.buffer = false
    self.timer:every(0.5, function ()
        self.on = not self.on
    end)
    Signal.emit('next')
end

function Tutorial:resume()
end

function Tutorial:leave()
    self.timer:clear()
    Signal.clear('next')
end

function Tutorial:update(dt)
    self.timer:update(dt)

    if not self.pause then
        self.prev:update(dt)
    end
end

function Tutorial:draw()
    self.prev:draw()

    love.graphics.push('all')
    self.current:draw()
    if self.pause and self.on then
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle('fill', self.current.pos.x + self.current:getWidth() + 5, self.current.pos.y + self.current:getHeight() + 5, 10, 10)
    end
    love.graphics.setColor(255, 255, 255)
    love.graphics.pop()
end

function Tutorial:keypressed(key)
end

function Tutorial:keyreleased(key)
    if self.pause and not self.buffer then
        Signal.emit('next')
        self.buffer = true
        self.timer:after(0.2, function () self.buffer = false end)
    end

    if self.pause and self.buffer and key == 'space' then
        Signal.emit('space')
    end
end

function Tutorial:mousepressed(x, y, btn)
    if not self.pause then
        self.prev:mousepressed(x, y, btn)
    end
end

function Tutorial:mousereleased(x, y, btn)
end

return Tutorial