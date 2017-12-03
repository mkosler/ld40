Gamestate = require 'lib.hump.gamestate'
Class = require 'lib.hump.class'
Vector = require 'lib.hump.vector'
Timer = require 'lib.hump.timer'
Utils = require 'src.utils'
Bowl = require 'src.bowl'
Spice = require 'src.spice'
Order = require 'src.order'

STATES = {}
ASSETS = {
    ['soup'] = love.graphics.newImage('assets/soup.png'),
    ['tray'] = love.graphics.newImage('assets/tray.png'),
    ['aqua-spice'] = love.graphics.newImage('assets/aqua-spice.png'),
    ['blue-spice'] = love.graphics.newImage('assets/blue-spice.png'),
    ['fuchisa-spice'] = love.graphics.newImage('assets/fuchisa-spice.png'),
    ['green-spice'] = love.graphics.newImage('assets/green-spice.png'),
    ['red-spice'] = love.graphics.newImage('assets/red-spice.png'),
    ['yellow-spice'] = love.graphics.newImage('assets/yellow-spice.png'),
    ['order'] = love.graphics.newImage('assets/order.png'),
    ['progress'] = love.graphics.newImage('assets/progress.png'),
    ['bracket'] = love.graphics.newImage('assets/bracket.png'),
    ['soup-small'] = love.graphics.newImage('assets/soup-small.png'),
    ['success'] = love.graphics.newImage('assets/success.png'),
    ['failure'] = love.graphics.newImage('assets/failure.png'),
}
COLORS = {
    red = { 255, 0, 0 },
    green = { 0, 255, 0 },
    blue = { 0, 0, 255 },
    yellow = { 255, 255, 0 },
    fuchisa = { 255, 0, 255 },
    aqua = { 0, 255, 255 }
}

function love.load()
    math.randomseed(os.time())
    love.graphics.setBackgroundColor(116, 164, 242)

    for _,v in ipairs(love.filesystem.getDirectoryItems('src/states')) do
        local name = string.upper(string.match(v, '(.+).lua$'))
        STATES[name] = require('src/states/'..name)
    end

    Gamestate.registerEvents()
    Gamestate.switch(STATES.PREPLAY, 2)
end

function love.update(dt)
    Timer.update(dt)
end