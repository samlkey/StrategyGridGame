local class = require("module/class")

local sprite = class:extend("sprite")

function sprite:new(x, y, width, height, image, ox, oy)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.ox = ox or 0
    self.oy = oy or 0
    
    -- Add error handling for image loading
    local success, result = pcall(function()
        return love.graphics.newImage(image)
    end)
    
    if success then
        self.image = result
    else
        print("Warning: Could not load image: " .. image)
        self.image = nil
    end
end

function sprite:draw()
    if self.image then
        love.graphics.draw(self.image, self.x, self.y, 0, self.width / self.image:getWidth(), self.height / self.image:getHeight(), self.ox, self.oy)
    else
        -- Draw a colored rectangle as fallback
        love.graphics.setColor(1, 0, 1) -- Magenta color to make it obvious
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
        love.graphics.setColor(1, 1, 1) -- Reset color
    end

    -- Draw debug rectangle if in debug mode
    if DEBUG then
        love.graphics.setColor(1, 0, 1) -- Magenta color to make it obvious
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
        love.graphics.setColor(1, 1, 1) -- Reset color
    end
end

function sprite:move(x, y)
    self.x = x
    self.y = y
end


return sprite

