local Gamestate = require 'lib.hump.gamestate'

function love.load()
    Gamestate.registerEvents()
end