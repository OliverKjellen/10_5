 --[[
        Copyright Oliver Kjellén 2020
    ]]--

--Shortening some keywords--
p = love.physics
g = love.graphics
k = love.keyboard
jit.off()
--Setting font
font = g.newFont("resources/jackeyfont.ttf", 64)
g.setFont(font)

pattern = love.graphics.newImage("resources/pattern.png")


--Global variables--
SpeedRun = false
mouseMoved = false
mouseX = 0
mouseY = 0
mouseDown = false
width = g.getWidth()
osString = love.system.getOS()
mobile = false

--Shaders loaded--
crtShader = love.graphics.newShader("shaders/crt.shader")
posterize = love.graphics.newShader("shaders/posterize.shader")
scanlines = love.graphics.newShader("shaders/scanlines.shader")
chromasep = love.graphics.newShader("shaders/chromasep.shader")
----------------
math.randomseed(os.time())


--Local variables--
local screenChangeValue = 1
local rw, rh, rf = love.window.getMode()

if osString == "Android" or osString == "iOS" then
    mobile = true
end

--Great library for handling scaling for different screen sizes (desktop, mobile and so on)
push = require "push"
-----------------Push setup------------------------------------------------------
local gameWidth, gameHeight = 1280, 720
local screenWidth, screenHeight = love.window.getDesktopDimensions()
local dpi_scale = love.window.getDPIScale()
if mobile then
    screenWidth, screenHeight = screenWidth*1, screenHeight*1.11
    screenWidth = screenWidth/dpi_scale
    screenHeight = screenHeight/dpi_scale
    screenHeight = screenHeight
else
    screenWidth, screenHeight = screenWidth*0.7, screenHeight*0.7
    screenWidth = screenWidth/dpi_scale
    screenHeight = screenHeight/dpi_scale
end
push:setupScreen(gameWidth, gameHeight, screenWidth, screenHeight, {fullscreen = true, resizable = true, canvas = true, pixelperfect = false, highdpi = true, stretched = false})
---------------Push setup end-----------------------------------------------------

--Requiring modules--
require("scripts.player")
require("scripts.transition")
require("state.introTutorial")
require("state.stateHandler")
require("state.menu")
require("state.game")
require("state.pause")
require("state.gameOver")
require("scripts.soundHandler")
require("scripts.touchControls")
require("scripts.text")
require("scripts.dataHandler")
require("scripts.settingsChanger")
require("Levels.LevelHandler")
require("scripts.menuSystem")
require("scripts.diamonds")
require("scripts.grass")
require("state.miniGameVVVVV")
require("scripts.collisionHandler")
require("scripts.artGallery")
--Great library, using it for timers and tweening--
Timer = require("hump.timer")
--Great library to handle camera emulation--
Camera = require "gamera"



--If playing for the first time init a save file--
if DataHandler:loadGame() == nil then
    DataHandler:init()
    DataHandler:initVVVVV()
    DataHandler:initSettings()
end
--DataHandler:initSettings()
--Start at the menu state--
States.menu = true
State:menuStart()

--Loading various things at startup--
function love.load()
    camera = Camera()
    camera.scale = 0.8
    camera:setFollowStyle('PLATFORMER')
    push:setShader({ crtShader, chromasep, scanlines })

    phase = 0
    complete = false
    angle = 0.005
    completeChroma = false
    scanlines:send("time", 1)
    scanlines:send("setting1", 640.0)
    scanlines:send("setting2", 640.0)
    crtShader:send("feather", 0.02)
    crtShader:send("distortionFactor", {1.06, 1.065})
    crtShader:send("scaleFactor", 1)

    TouchControls:init(1)
end
--Main update function--
function love.update(dt)
    Timer.update(dt)
    State:stateChanger(dt)
    camera:update(dt)
    SoundHandler:updateVolumes()
    if mobile then
        if Player:getPositionX() ~= nil then
            camera:follow(Player:getPositionX() - 200, Player:getPositionY() - 120)
        end
    else
        if Player:getPositionX() ~= nil then
            camera:follow(Player:getPositionX() - 10, Player:getPositionY() + 50)
        end
    end
    love.window.setTitle(tostring(love.timer.getFPS()))
end

--Main draw function--
function love.draw()
    push:apply("start")
        if States.change == false then
            if States.game == true then
                camera:attach()
                    Game:draw()
                camera:detach()
            elseif States.intro == true then
                introTutorial:draw()
            elseif States.menu == true then
                Menu:draw()    
            elseif States.paused == true then
                Pause:draw()
            elseif States.gameOver == true then
                GameOver:draw()
            elseif States.miniGame1 == true then
                MiniGameVVVVV:draw()
                TouchControls:draw()
            end
            if States.game and Game:isLevelChange() == false or States.menu and MenuSystem:StartedMenuGame() then
                TouchControls:draw()
            end
            
            Transition:draw()
            if Text:getStatus() ~= nil and States.game then
                Text:draw()
                Text:dialogDraw()
                Diamonds:drawCount()
            end
            
        end
    push:apply("end")
end

--This is used to resize the screen filters correctly
function love.resize(rw, rh)
    push:resize(rw, rh)
end

--Change from fullscreen to windowed mode on desktop--
function love.keyreleased(key)
    if key == "f" then
        if screenChangeValue % 2 ~= 0 then
            love.window.setFullscreen(false, "desktop")
        else
            love.window.setFullscreen(true, "desktop")
        end
        screenChangeValue = screenChangeValue + 1
    end
end
