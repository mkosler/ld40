Gamestate = require 'lib.hump.gamestate'
Class = require 'lib.hump.class'
Vector = require 'lib.hump.vector'
Timer = require 'lib.hump.timer'
Utils = require 'src.utils'
STATES = {}
ASSETS = {}
COLORS = {
    red = { 255, 0, 0 },
    green = { 0, 255, 0 },
    blue = { 0, 0, 255 },
    yellow = { 255, 255, 0 },
    fuchisa = { 255, 0, 255 },
    aqua = { 0, 255, 255 }
}

function love.load()
    for _,v in ipairs(love.filesystem.getDirectoryItems('src/states')) do
        local name = string.upper(string.match(v, '(.+).lua$'))
        STATES[name] = require('src/states/'..name)
    end

    Gamestate.registerEvents()
    Gamestate.switch(STATES.PLAY)
end

function love.update(dt)
    Timer.update(dt)
end