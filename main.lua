local GRID = require("struct/grid")
local PLAYER = require("entities/player")
local NPC = require("entities/npc")
local OBJECT = require("entities/object")
local CONTROLS = require("module/controls")
local SCENE = require("module/scene")
local CAMERA = require("libraries/camera")
local STI = require("libraries/sti")

--load(), present on game start/load
function love.load()
    -- Libraries
    overworld = STI("maps/overworld.lua")
    camera = CAMERA()

    
    -- Debug mode
    DEBUG = false
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()
    debugKeyPressed = false

    -- Initialize controls
    controls = CONTROLS()
    
    -- Initialize scene manager
    gameScene = SCENE()

    -- Grid
    -- Change this to be a battle.lua object
    local gridCells = 8
    local cellSize = 60

    local gridSize = gridCells * cellSize
    local xOfset = 200
    
    local gridOriginX = ((screenWidth + xOfset) - gridSize) / 2
    local gridOriginY = (screenHeight - gridSize) / 2

    bGrid = GRID(gridCells, cellSize, gridOriginX, gridOriginY)
    
    -- Create entities
    player = PLAYER(100, 100, 70)
    npc = NPC(200, 200, 70, "Hello, I'm an NPC!", 1)
    object = OBJECT(300, 300, 70)
    
    -- Add entities to appropriate scenes
    -- Eventually want to be adding maps to the scene manager
    gameScene:addEntity(player, "overworld")
    gameScene:addEntity(npc, "overworld")
    gameScene:addEntity(object, "overworld")

    -- Add grid to battle scene
    gameScene:addEntity(bGrid, "battle")
    
    -- Store entities globally for collision checking
    renderedEntities = gameScene:getCurrentEntities()
end

--update(), called every frame
function love.update(dt)
    -- Handle player input in overworld mode
    if gameScene.currentScene == gameScene.SCENES.OVERWORLD then
        player:handleInput(controls)
    end

    -- Update current scene
    gameScene:update(dt)

    -- Switch scenes with debug key
    if controls:isDown("debug") then
        if not debugKeyPressed then
            DEBUG = not DEBUG
            debugKeyPressed = true

            --Stats
            if DEBUG then
                print("Rendered Entities: " .. #renderedEntities)
            end
        end
    else
        debugKeyPressed = false
    end

    -- Camera
    camera:lookAt(player.x, player.y)

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    -- Camera bounds
    if camera.x < w/2 then
        camera.x = w/2
    end

    if camera.y < h/2 then
        camera.y = h/2
    end

    local mapW = gameScene:getMap().width * gameScene:getMap().tilewidth
    local mapH = gameScene:getMap().height * gameScene:getMap().tileheight

    if camera.x > mapW - w/2 then
        camera.x = mapW - w/2
    end

    if camera.y > mapH - h/2 then
        camera.y = mapH - h/2
    end
end

--draw(), used to draw graphics/text to the screen
function love.draw()
    camera:attach()
    gameScene:draw()
    camera:detach()
end

-- Forward joystick events to controls module
function love.joystickadded(joystick)
    controls:joystickAdded(joystick)
end

function love.joystickremoved(joystick)
    controls:joystickRemoved(joystick)
end

-- https://www.youtube.com/watch?v=wttKHL90Ank