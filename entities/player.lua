local class = require("module/class")
local sprite = require("module/sprite")
local player = class:extend("player")
local collision_box = require("module/collision_box")

function player:new(x, y, size)
    self.x = x
    self.y = y
    self.size = size
    self.speed = 5
    self.sprite = sprite(x, y, self.size, self.size, "assets/player.png")
    self.collision_box = collision_box(x, y, self.size, self.size, 0)
    
    -- Store screen dimensions for bounds checking
    self.screenWidth = love.graphics.getWidth()
    self.screenHeight = love.graphics.getHeight()
end

function player:draw()
    self.sprite:draw()

    -- Draw debug rectangle if in debug mode
    if DEBUG then
        self.collision_box:draw()
        love.graphics.rectangle("line", self.x, self.y, self.size, self.size)
    end
end

function player:move(x, y)
    -- Store current position
    local oldX = self.x
    local oldY = self.y
    
    -- Try moving to new position
    self.x = x
    self.y = y
    self.collision_box:move(x, y)
    
    -- Check if the player is colliding with any other entities
    for _, entity in ipairs(renderedEntities) do
        if entity ~= self and entity.collision_box then
            if self.collision_box:checkCollision(entity.collision_box) then
                self.x = oldX
                self.y = oldY
                self.collision_box:move(oldX, oldY)
                return
            end
        end
    end
    
    -- If no collision, update sprite position
    self.sprite:move(x, y)
end

function player:handleInput(controls)
    -- Get movement vector from controls
    local moveX, moveY = controls:getMovementVector()
    
    -- Apply movement if within bounds
    if moveX ~= 0 then
        local newX = self.x + (moveX * self.speed)
        if newX >= 0 and newX <= self.screenWidth - self.size then
            self:move(newX, self.y)
        end
    end
    
    if moveY ~= 0 then
        local newY = self.y + (moveY * self.speed)
        if newY >= 0 and newY <= self.screenHeight - self.size then
            self:move(self.x, newY)
        end
    end
    
    -- Check for interaction
    if controls:isDown("interact") then
        self:interact()
    end
end

function player:interact()
    -- Check if the player is in any triggers
    for _, entity in ipairs(renderedEntities) do
        if entity.interactionCollisionBox then
            if self.collision_box:checkCollision(entity.interactionCollisionBox) then
                return entity:interact()
            end
        end
    end
end

return player

