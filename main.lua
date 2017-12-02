Gamestate = require 'lib.hump.gamestate'
Class = require 'lib.hump.class'
Vector = require 'lib.hump.vector'
Utils = require 'src.utils'
STATES = {}
ASSETS = {}

function love.load()
    for _,v in ipairs(love.filesystem.getDirectoryItems('src/states')) do
        local name = string.upper(string.match(v, '(.+).lua$'))
        STATES[name] = require('src/states/'..name)
    end

    Gamestate.registerEvents()
    Gamestate.switch(STATES.PLAY)
end