local COLOR_DELTA = {
    red     = {  1.0, -0.5, -0.5 },
    green   = { -0.5,  1.0, -0.5 },
    blue    = { -0.5, -0.5,  1.0 },
    yellow  = {  0.5,  0.5, -1.0 },
    fuchisa = {  0.5, -1.0,  0.5 },
    aqua    = { -1.0,  0.5,  0.5 },
}

return Class{
    init = function (self, levels)
        self.levels = levels
        self.color = {0, 0, 0, 255}
    end,

    modify = function (self, color, rate)
        local dc = COLOR_DELTA[color]

        for i,v in ipairs(self.color) do
            v = dc[i] * rate
        end
    end,

    draw = function (self, pos, radius)
        love.graphics.push('all')
        love.graphics.translate(pos.x, pos.y)
        love.graphics.setColor(self.color)
        love.graphics.circle('fill', 0, 0, radius)
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.setLineWidth(5)
        love.graphics.circle('line', 0, 0, radius)
        love.graphics.pop()
    end
}