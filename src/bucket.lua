local COLOR_DELTA = {
    red     = {  1.0, -0.5, -0.5 },
    green   = { -0.5,  1.0, -0.5 },
    blue    = { -0.5, -0.5,  1.0 },
    yellow  = {  0.5,  0.5, -1.0 },
    fuchisa = {  0.5, -1.0,  0.5 },
    aqua    = { -1.0,  0.5,  0.5 },
}

return Class{
    init = function (self, levels, pos, radius)
        self.levels = levels
        self.pos = pos
        self.radius = radius
        self.color = {0, 0, 0, 255}
    end,

    modify = function (self, color, rate)
        if not color then return end

        local dc = COLOR_DELTA[color]

        for i,v in ipairs(dc) do
            self.color[i] = Utils.clamp(self.color[i] + (v * rate), 0, 255)
        end
    end,

    draw = function (self)
        love.graphics.push('all')
        love.graphics.translate(self.pos.x, self.pos.y)
        love.graphics.setColor(self.color)
        love.graphics.circle('fill', 0, 0, self.radius)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.setLineWidth(5)
        love.graphics.circle('line', 0, 0, self.radius)
        love.graphics.pop()
    end
}