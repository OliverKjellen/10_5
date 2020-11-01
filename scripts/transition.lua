
--[[
    Draws a transition effect when transitioning from the menu.
]]--

Transition = {}

local color = ""
local transitioning = false

local curtain1 = {}
curtain1[1] = {x = 0, y = 1200} 

function Transition:init()
    curtain1[1] = {x = 0, y = 1200} 
end

function Transition:draw()
    g.setColor(1, 1, 1)
    if color == "" then
        g.setColor(1, 1, 1)
    else
        g.setColor(LevelHandler:colors(1))
    end
    g.rectangle("fill", curtain1[1].x, curtain1[1].y, 1280, 720)
end

function Transition:activate(choice)
    transitioning = true
    if choice then
        color = "asLevel"
    else
        color = ""
    end
    local function move()
        Timer.tween(1.3, curtain1[1], {y = 0}, 'in-out-quad')
        Timer.script(function(wait)
            wait(2.4)
            Timer.tween(1.3, curtain1[1], {y = 1200}, 'in-out-quad')
        end)
        Timer.script(function(wait)
            wait(4.0)
            transitioning = false
        end)
    end
    move()
end

function Transition:getState()
    return transitioning
end