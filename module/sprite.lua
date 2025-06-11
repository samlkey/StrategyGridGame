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
        -- Calculate scale to fit the desired dimensions
        local scaleX = self.width / self.image:getWidth()
        local scaleY = self.height / self.image:getHeight()
        
        -- If no offset or offset is 0, use normal drawing
        if (self.ox == 0 and self.oy == 0) then
            love.graphics.draw(
                self.image,
                self.x,
                self.y,
                0,  -- rotation
                scaleX,
                scaleY
            )
        else
            -- Draw the image with center offset
            love.graphics.draw(
                self.image,
                self.x,
                self.y,
                0,  -- rotation
                scaleX,
                scaleY,
                self.image:getWidth()/2,  -- Center the origin of the image
                self.image:getHeight()/2   -- Center the origin of the image
            )
        end
    else
        -- Draw a colored rectangle as fallback
        love.graphics.setColor(1, 0, 1) -- Magenta color to make it obvious
        love.graphics.rectangle("fill", self.x - self.ox, self.y - self.oy, self.width, self.height)
        love.graphics.setColor(1, 1, 1) -- Reset color
    end

    -- Draw debug rectangle if in debug mode
    if DEBUG then
        love.graphics.setColor(1, 0, 1) -- Magenta color to make it obvious
        love.graphics.rectangle("line", self.x - self.ox, self.y - self.oy, self.width, self.height)
        love.graphics.setColor(1, 1, 1) -- Reset color
    end
end

function sprite:move(x, y)
    self.x = x
    self.y = y
end

return sprite

