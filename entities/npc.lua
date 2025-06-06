local class = require("module/class")
local sprite = require("module/sprite")
local collision_box = require("module/collision_box")
local dialog = require("module/dialog")
local npc = class:extend("npc")

function npc:new(x, y, size)
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
    self.dialogue = "Hello, I'm an NPC!"

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
end

return npc
