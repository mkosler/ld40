Gamestate = require 'lib.hump.gamestate'
Class = require 'lib.hump.class'
Vector = require 'lib.hump.vector'
Timer = require 'lib.hump.timer'
Signal = require 'lib.hump.signal'
Utils = require 'src.utils'
Bowl = require 'src.bowl'
Spice = require 'src.spice'
Order = require 'src.order'
Label = require 'src.label'

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
    ['title-screen'] = love.graphics.newImage('assets/title-screen.png'),
    ['play-blur'] = love.graphics.newImage('assets/play-blur.png'),
    ['tutorial-blur'] = love.graphics.newImage('assets/tutorial-blur.png'),
    ['quit-blur'] = love.graphics.newImage('assets/quit-blur.png'),
    ['font-18'] = love.graphics.newFont('assets/CaviarDreams.ttf', 18),
    ['font-18-bold'] = love.graphics.newFont('assets/CaviarDreams_Bold.ttf', 18),
    ['font-30'] = love.graphics.newFont('assets/CaviarDreams.ttf', 30),
    ['font-30-bold'] = love.graphics.newFont('assets/CaviarDreams_Bold.ttf', 30),
    ['red-cursor'] = love.mouse.newCursor('assets/spicy-cursor.png'),
    ['green-cursor'] = love.mouse.newCursor('assets/salty-cursor.png'),
    ['blue-cursor'] = love.mouse.newCursor('assets/acidic-cursor.png'),
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
    love.graphics.setFont(ASSETS['font-18-bold'])

    for _,v in ipairs(love.filesystem.getDirectoryItems('src/states')) do
        local name = string.upper(string.match(v, '(.+).lua$'))
        STATES[name] = require('src/states/'..name)
    end

    Gamestate.registerEvents()
    Gamestate.switch(STATES.TITLE, 2)
end

function love.update(dt)
    Timer.update(dt)
end