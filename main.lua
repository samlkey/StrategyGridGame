local GRID = require("struct/grid")
local PLAYER = require("entities/player")
local NPC = require("entities/npc")
local OBJECT = require("entities/object")
local CONTROLS = require("module/controls")
local SCENE = require("module/scene")

--load(), present on game start/load
function love.load()
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
    npc2 = NPC(600, 300, 70, "Lets fight!", 0)
    object = OBJECT(300, 300, 70)
    
    -- Add entities to appropriate scenes
    -- Eventually want to be adding maps to the scene manager
    gameScene:addEntity(player, "overworld")
    gameScene:addEntity(npc, "overworld")
    gameScene:addEntity(npc2, "overworld")
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
        end
    else
        debugKeyPressed = false
    end
end

--draw(), used to draw graphics/text to the screen
function love.draw()
    gameScene:draw()
end

-- Forward joystick events to controls module
function love.joystickadded(joystick)
    controls:joystickAdded(joystick)
end

function love.joystickremoved(joystick)
    controls:joystickRemoved(joystick)
end

-- https://www.youtube.com/watch?v=wttKHL90Ank