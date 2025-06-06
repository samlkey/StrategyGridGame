local GRID = require("struct/grid")
local PLAYER = require("entities/player")
local NPC = require("entities/npc")
local OBJECT = require("entities/object")

--load(), present on game start/load
function love.load()
    -- Debug mode
    DEBUG = false
    screenWidth = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()
    debugKeyPressed = false

    -- Rendered entities
    renderedEntities = {}

    -- Grid
    local gridCells = 8
    local cellSize = 60

    local gridSize = gridCells * cellSize
    local xOfset = 200
    
    local gridOriginX = ((screenWidth + xOfset) - gridSize) / 2
    local gridOriginY = (screenHeight - gridSize) / 2

    bGrid = GRID(gridCells, cellSize, gridOriginX, gridOriginY)
    
    -- Entities
    player = PLAYER(100, 100, 70)
    npc = NPC(200, 200, 70)
    table.insert(renderedEntities, player)
    table.insert(renderedEntities, npc)

    -- Objects
    object = OBJECT(300, 300, 70)
    table.insert(renderedEntities, object)
    
    -- Initialize joystick state
    joysticks = love.joystick.getJoysticks()
    activeJoystick = joysticks[1]
end

--update(), called every frame
function love.update(dt)
    -- Game mode, 0 = overworld, 1 = battle
    mode = 0

    -- Player controlls
    if mode == 0 then
        handlePlayerInput()
        -- Interact with NPCs
        if love.keyboard.isDown("e") then
            player:interact()
        end
    end

    -- Switch debug mode
    if love.keyboard.isDown("f1") then
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
    -- if i = draw bGrid
    if mode == 1 then
        -- Clear screen
        love.graphics.clear()
        bGrid:draw()
    else
        -- Draw entities
        for _, entity in ipairs(renderedEntities) do
            entity:draw()
        end
    end
end

function handlePlayerInput()
    -- Move player if key/button pressed
    -- Check vertical movement
    local verticalInput = 0
    local horizontalInput = 0
    
    -- Get joystick input if a joystick is connected
    if activeJoystick then
        verticalInput = activeJoystick:getAxis(2)
        horizontalInput = activeJoystick:getAxis(1)
    end
    
    if (love.keyboard.isDown("up", "w") or (activeJoystick and verticalInput < -0.2)) and player.y > 0 then
        player:move(player.x, player.y - player.speed)
    end
    if (love.keyboard.isDown("down", "s") or (activeJoystick and verticalInput > 0.2)) and player.y < screenHeight - player.size then
        player:move(player.x, player.y + player.speed)
    end
    
    -- Check horizontal movement
    if (love.keyboard.isDown("left", "a") or (activeJoystick and horizontalInput < -0.2)) and player.x > 0 then
        player:move(player.x - player.speed, player.y)
    end
    if (love.keyboard.isDown("right", "d") or (activeJoystick and horizontalInput > 0.2)) and player.x < screenWidth - player.size then
        player:move(player.x + player.speed, player.y)
    end
end

-- Joystick connection handlers
function love.joystickadded(joystick)
    if not activeJoystick then
        activeJoystick = joystick
    end
end

function love.joystickremoved(joystick)
    if activeJoystick == joystick then
        joysticks = love.joystick.getJoysticks()
        activeJoystick = joysticks[1]
    end
end

-- https://www.youtube.com/watch?v=wttKHL90Ank