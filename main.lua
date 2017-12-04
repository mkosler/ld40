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

STATES = {
    PLAY = require 'src.states.play',
    TITLE = require 'src.states.title',
    TUTORIAL = require 'src.states.tutorial',
    VICTORY = require 'src.states.victory',
}
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
    ['spicy-icon'] = love.graphics.newImage('assets/spicy-cursor.png'),
    ['salty-icon'] = love.graphics.newImage('assets/salty-cursor.png'),
    ['acidic-icon'] = love.graphics.newImage('assets/acidic-cursor.png'),
    ['return-blur'] = love.graphics.newImage('assets/return-blur.png'),
    ['paycheck'] = love.graphics.newImage('assets/paycheck.png'),
    ['success-sfx'] = love.audio.newSource('assets/success.ogg', 'static'),
    ['failure-sfx'] = love.audio.newSource('assets/failure.ogg', 'static'),
    ['loop-sfx'] = love.audio.newSource('assets/loop.ogg'),
}
COLORS = {
    red = { 255, 0, 0 },
    green = { 0, 255, 0 },
    blue = { 0, 0, 255 },
}

function love.load()
    math.randomseed(os.time())
    love.graphics.setFont(ASSETS['font-18-bold'])

    ASSETS['red-cursor'] = love.mouse.newCursor(ASSETS['spicy-icon']:getData())
    ASSETS['green-cursor'] = love.mouse.newCursor(ASSETS['salty-icon']:getData())
    ASSETS['blue-cursor'] = love.mouse.newCursor(ASSETS['acidic-icon']:getData())

    -- configure particle systems
    ASSETS['red-particle'] = love.graphics.newParticleSystem(ASSETS['spicy-icon'], 100)
    ASSETS['red-particle']:setParticleLifetime(1, 2)
    ASSETS['red-particle']:setEmissionRate(10)
    ASSETS['red-particle']:setSizes(0.25)
    ASSETS['red-particle']:setColors(255, 255, 255, 255, 255, 255, 255, 0)
    ASSETS['red-particle']:setLinearAcceleration(-70, 25, -10, 100)
    ASSETS['red-particle']:stop()

    ASSETS['green-particle'] = love.graphics.newParticleSystem(ASSETS['salty-icon'], 100)
    ASSETS['green-particle']:setParticleLifetime(1, 2)
    ASSETS['green-particle']:setEmissionRate(10)
    ASSETS['green-particle']:setSizes(0.25)
    ASSETS['green-particle']:setColors(255, 255, 255, 255, 255, 255, 255, 0)
    ASSETS['green-particle']:setLinearAcceleration(-70, 25, -10, 100)
    ASSETS['green-particle']:stop()

    ASSETS['blue-particle'] = love.graphics.newParticleSystem(ASSETS['acidic-icon'], 100)
    ASSETS['blue-particle']:setParticleLifetime(1, 2)
    ASSETS['blue-particle']:setEmissionRate(10)
    ASSETS['blue-particle']:setSizes(0.25)
    ASSETS['blue-particle']:setColors(255, 255, 255, 255, 255, 255, 255, 0)
    ASSETS['blue-particle']:setLinearAcceleration(-70, 25, -10, 100)
    ASSETS['blue-particle']:stop()

    -- for _,v in ipairs(love.filesystem.getDirectoryItems('src/states')) do
    --     local name = string.upper(string.match(v, '(.+).lua$'))
    --     STATES[name] = require('src/states/'..name)
    -- end

    mute = false

    Gamestate.registerEvents()
    Gamestate.switch(STATES.TITLE, 2)
end

function love.update(dt)
    Timer.update(dt)
end

function love.draw()
    -- love.graphics.print(love.timer.getFPS())
end

function love.keypressed(key)
    if key == 'm' then
        mute = not mute
        ASSETS['loop-sfx']:setVolume(mute and 1 or 0)
    end
end