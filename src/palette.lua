return Class{
    init = function (self, queue, pos)
        self.queue = queue
        self.pos = pos
        self.active = queue[1]
    end,

    use = function (self, rate)
        if self.active.amount <= 0 and #self.queue > 1 then
            table.remove(self.queue, 1)
            self.active = self.queue[1]
        end

        if self.active.amount > 0 then
            self.active.amount = self.active.amount - rate
            return self.active.color
        end

        return nil
    end,

    draw = function (self)
        local size = 20
        love.graphics.push('all')
        love.graphics.translate(self.pos.x, self.pos.y)
        for i, v in pairs(self.queue) do
            if i <= 3 then
                love.graphics.setColor(COLORS[v.color])
                love.graphics.rectangle('fill', 0, size * (3 - i - 1), size, size * (v.amount / v.capacity))
            end
        end
        love.graphics.pop()
    end
}