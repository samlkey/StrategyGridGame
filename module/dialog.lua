local class = require("module/class")
local dialog = class:extend("dialog")

function dialog:new(text)
    self.text = text
end

function dialog:draw()
    -- Store the dialogue text
    local text = self.text
    -- Split dialogue into characters
    local chars = {string.byte(text, 1, #text)}
    
    -- Calculate position at bottom of screen
    local textY = love.graphics.getHeight() - 100
    local textX = 50
    
    -- Draw text background
    love.graphics.setColor(0, 0, 0, 0.8) 
    love.graphics.rectangle("fill", 0, textY - 20, love.graphics.getWidth(), 120)
    love.graphics.setColor(1, 1, 1, 1)
    
    -- Set larger font size
    love.graphics.setNewFont(24)
    
    -- Print each character with delay
    local displayText = ""
    for i, char in ipairs(chars) do
        displayText = displayText .. string.char(char)
        love.graphics.print(displayText, textX, textY)
        love.graphics.present()
        love.timer.sleep(0.05)
    end
    
    -- Reset font size
    love.graphics.setNewFont(12)
    love.timer.sleep(1)
end

return dialog