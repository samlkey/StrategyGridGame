local class = require("module/class")
local collision_box = class:extend("collision_box")

function collision_box:new(x, y, width, height, type, isTrigger)
    --type 0 = circle, 1 = rectangle
    self.type = type
    -- Store original dimensions for both types
    self.width = width
    self.height = height
    self.isTrigger = isTrigger

    if type == 0 then
        self.radius = math.min(width, height)/2 -- Use smaller dimension for radius
        self.x = x + self.radius  -- Store center x
        self.y = y + self.radius  -- Store center y
    elseif type == 1 then
        self.x = x
        self.y = y
    end
end

function collision_box:draw()
    if self.isTrigger then
        love.graphics.setColor(1, 0, 0, 0.5) -- Set color to transparent red
    else
        love.graphics.setColor(0, 1, 0, 0.5) -- Set color to transparent green
    end

    if self.type == 0 then
        love.graphics.circle("fill", self.x, self.y, self.radius)
    elseif self.type == 1 then
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    end
    love.graphics.setColor(1, 1, 1, 1) -- Reset color
end

function collision_box:move(x, y)
    if self.type == 0 then
        -- For circles, update center position
        self.x = x + self.radius
        self.y = y + self.radius
    elseif self.type == 1 then
        -- For rectangles, update top-left corner
        self.x = x
        self.y = y
    end
end

function collision_box:checkCollision(other)
    -- Handle circle-circle collision
    if self.type == 0 and other.type == 0 then
        local dx = self.x - other.x
        local dy = self.y - other.y
        local distance = math.sqrt(dx * dx + dy * dy)
        return distance < (self.radius + other.radius)
    
    -- Handle rectangle-rectangle collision
    elseif self.type == 1 and other.type == 1 then
        return self.x < other.x + other.width and
               self.x + self.width > other.x and
               self.y < other.y + other.height and
               self.y + self.height > other.y
               
    -- Handle circle-rectangle collision
    elseif self.type == 0 and other.type == 1 then
        -- Find closest point on rectangle to circle center
        local closestX = math.max(other.x, math.min(self.x, other.x + other.width))
        local closestY = math.max(other.y, math.min(self.y, other.y + other.height))
        
        -- Calculate distance between closest point and circle center
        local dx = self.x - closestX
        local dy = self.y - closestY
        local distance = math.sqrt(dx * dx + dy * dy)
        
        return distance < self.radius
    end
end

return collision_box
