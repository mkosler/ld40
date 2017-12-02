local COLOR_DELTA = {
    red     = {  1.0, -0.5, -0.5 },
    green   = { -0.5,  1.0, -0.5 },
    blue    = { -0.5, -0.5,  1.0 },
    yellow  = {  0.5,  0.5, -1.0 },
    fuchisa = {  0.5, -1.0,  0.5 },
    aqua    = { -1.0,  0.5,  0.5 },
}

return Class{
    init = function (self, levels, pos)
        self.levels = levels
        self.pos = pos
        self.current = { 0, 0, 0 }
    end,

    modify = function (self, color, rate)
        if not color then return end

        local dc = COLOR_DELTA[color]

        for i,v in ipairs(dc) do
            self.current[i] = Utils.clamp(self.current[i] + (v * rate), 0, 100)
        end
    end,

    draw = function (self)
        love.graphics.push('all')
        love.graphics.translate(self.pos.x, self.pos.y)
        love.graphics.draw(ASSETS['soup'], 0, 0)
        love.graphics.push()
        love.graphics.translate(ASSETS['soup']:getWidth() / 2 - ASSETS['order']:getWidth() / 2, ASSETS['soup']:getHeight() - 70)
        love.graphics.draw(ASSETS['order'], 0, 0)
        self:drawLevel(self.levels.spicy, self.current[1], 70, 50)
        self:drawLevel(self.levels.salty, self.current[2], 70, 90)
        self:drawLevel(self.levels.acidic, self.current[3], 70, 130)
        love.graphics.pop()
        love.graphics.pop()
    end,

    drawLevel = function (self, level, current, x, y)
        love.graphics.push()
        love.graphics.translate(x, y)
        love.graphics.draw(ASSETS['progress'], 0, 0)
        love.graphics.push('all')
        love.graphics.setColor(0, 0, 0)
        love.graphics.setLineWidth(3)
        love.graphics.line(ASSETS['progress']:getWidth() * current / 100, -1, ASSETS['progress']:getWidth() * current / 100, ASSETS['progress']:getHeight() + 2)
        love.graphics.pop()
        love.graphics.draw(ASSETS['bracket'], (ASSETS['progress']:getWidth() * level.min / 100) - 1, ASSETS['progress']:getHeight() / 2 - ASSETS['bracket']:getHeight() / 2 + 0.5)
        love.graphics.draw(ASSETS['bracket'], (ASSETS['progress']:getWidth() * level.max / 100) - 1, ASSETS['progress']:getHeight() / 2 - ASSETS['bracket']:getHeight() / 2 + 0.5, 0, -1, 1)
        love.graphics.pop()
    end,
}