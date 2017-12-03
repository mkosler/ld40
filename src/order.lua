return Class{
    init = function(self, count)
        self.count = count
    end,

    getNextOrder = function (self)
        if self.count <= 0 then return nil end
        self.count = self.count - 1

        local dx = 10
        local spicy = math.random(dx + 5, 100 - dx)
        local salty = math.random(dx + 5, 100 - dx)
        local acidic = math.random(dx + 5, 100 - dx)
        local bowl = Bowl({
            spicy = { min = spicy - dx, max = spicy + dx },
            salty = { min = salty - dx, max = salty + dx },
            acidic = { min = acidic - dx, max = acidic + dx },
        })

        return {
            spices = {
                Spice('red'),
                Spice('green'),
                Spice('blue')
            },
            bowl = bowl
        }
    end
}