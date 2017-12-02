local SPICE_OPTIONS = {
    red,
    green,
    blue,
    yellow,
    fuchisa,
    aqua
}

return {
    generate = function ()
        local spiceCount = math.random(6)
        local bowlCount = math.random(10)
        local spices = {}
        local spiceOptionsCopy = table.move(SPICE_OPTIONS, 1, #SPICE_OPTIONS, 1, {})
        for i = 1, spiceCount do
            table.insert(spices, table.remove(spiceOptionsCopy, math.random(#spiceOptionsCopy)))
        end

        return generateSpecific(bowlCount, spices)
    end,

    generateSpecific = function (count, spices)
        return {
            count = count,
            spices = spices,
            getNextBowl = function (self)
                if self.count <= 0 then return nil end
                self.count = self.count - 1

                local spicy = math.random(10, 90)
                local salty = math.random(10, 90)
                local acidic = math.random(10, 90)

                return Bowl({
                    spicy = { min = spicy - 10, max = spicy + 10 },
                    salty = { min = salty - 10, max = salty + 10 },
                    acidic = { min = acidic - 10, max = acidic + 10 }
                }, Vector(0, 0))
            end
        }
    end
}