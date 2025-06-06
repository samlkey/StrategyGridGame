local class = require("module/class")
local sprite = require("module/sprite")
local collision_box = require("module/collision_box")
local dialog = require("module/dialog")
local npc = class:extend("npc")

function npc:new(x, y, size, dialogue, type)
    self.x = x
    self.y = y
    self.size = size
    self.sprite = sprite(x, y, self.size, self.size, "assets/npc.png")
    -- Regular collision box for physical collisions
    self.collision_box = collision_box(x, y, self.size, self.size, 0, false)
    
    -- NPC state
    self.state = "idle"
    self.target = nil
    self.path = nil
    self.speed = 200

    -- NPC properties
    self.dialogue = dialogue
    -- Type: 0 = enemy, 1 = ally
    self.type = type

    -- Create interaction trigger box centered on NPC
    local triggerSize = self.size * 2
    local triggerX = x - (triggerSize - self.size) / 2  -- Offset to center
    local triggerY = y - (triggerSize - self.size) / 2  -- Offset to center
    self.interactionCollisionBox = collision_box(triggerX, triggerY, triggerSize, triggerSize, 0, true)
end

function npc:draw()
    self.sprite:draw()

    -- Draw debug rectangle if in debug mode
    if DEBUG then
        love.graphics.rectangle("line", self.x, self.y, self.size, self.size)
        self.collision_box:draw()
        self.interactionCollisionBox:draw()
    end
end

function npc:move(x, y)
    self.x = x
    self.y = y
    -- Update both collision boxes when NPC moves
    self.collision_box:move(x, y)
    -- Update interaction trigger position
    local triggerSize = self.size * 2
    local triggerX = x - (triggerSize - self.size) / 2
    local triggerY = y - (triggerSize - self.size) / 2
    self.interactionCollisionBox:move(triggerX, triggerY)
    -- Update sprite position
    self.sprite:move(x, y)
end

function npc:interact()
    local dialog = dialog(self.dialogue)
    dialog:draw()

    if self.type == 0 then
        -- Switch between overworld and battle scenes
        if gameScene.currentScene == gameScene.SCENES.OVERWORLD then
            gameScene:switchTo("BATTLE")
        else
            gameScene:switchTo("OVERWORLD")
        end
        -- Update rendered entities for collision detection
        renderedEntities = gameScene:getCurrentEntities()
    end
end

return npc
