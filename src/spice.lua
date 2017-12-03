return Class{
    init = function (self, name)
        self.name = name
        self.pos = Vector(0, 0)
    end,

    bbox = function (self)
        return self.pos.x, self.pos.y, self.pos.x + ASSETS[self.name..'-spice']:getWidth(), self.pos.y + ASSETS[self.name..'-spice']:getHeight()
    end,

    select = function (self)
        return self.name
    end,

    draw = function (self)
        love.graphics.push('all')
        love.graphics.translate(self.pos.x, self.pos.y)
        love.graphics.draw(ASSETS[self.name..'-spice'], 0, 0)
        love.graphics.pop()
    end,
}