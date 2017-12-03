return Class{
    init = function (self, font, padding)
        font = font or love.graphics.getFont()
        self.pos = Vector(0, 0)
        self.text = love.graphics.newText(font, nil)
        self.padding = padding or 10
    end,

    setf = function (self, text, limit, align)
        align = align or 'left'
        self.text:setf(text, limit, align)
    end,

    getWidth = function (self)
        return self.text:getWidth() + (self.padding * 2)
    end,

    getHeight = function (self)
        return self.text:getHeight() + (self.padding * 2)
    end,

    centerOnScreen = function (self)
        self:center(love.graphics.getWidth(), love.graphics.getHeight())
    end,

    center = function (self, x, y, width, height)
        if not width then
            width = x
            x = 0
        end

        if not height then
            height = y
            y = 0
        end

        self.pos.x = (width / 2 - self:getWidth() / 2) + x
        self.pos.y = (height / 2 - self:getHeight() / 2) + y
    end,

    draw = function (self)
        love.graphics.push('all')
        love.graphics.translate(self.pos.x, self.pos.y)
        love.graphics.setColor(255, 255, 255)
        love.graphics.setLineWidth(3)
        love.graphics.rectangle('fill', 0, 0, self:getWidth(), self:getHeight())
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle('line', 0, 0, self:getWidth(), self:getHeight())
        love.graphics.draw(self.text, self.padding, self.padding)
        love.graphics.pop()
    end,
}