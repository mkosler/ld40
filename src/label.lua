return Class{
    init = function (self, font, padding)
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