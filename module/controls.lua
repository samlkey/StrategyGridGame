local class = require("module/class")
local controls = class:extend("controls")

function controls:new()
    -- Initialize joystick state
    self.joysticks = love.joystick.getJoysticks()
    self.activeJoystick = self.joysticks[1]
    
    -- Default control scheme
    self.scheme = {
        up = {"up", "w"},
        down = {"down", "s"},
        left = {"left", "a"},
        right = {"right", "d"},
        interact = {"e"},
        debug = {"f1"}
    }
    
    -- Joystick configuration
    self.joystickConfig = {
        moveVerticalAxis = 2,
        moveHorizontalAxis = 1,
        interactButton = 1,
        deadzone = 0.2
    }
end

function controls:isDown(action)
    -- Check keyboard controls
    if self.scheme[action] then
        for _, key in ipairs(self.scheme[action]) do
            if love.keyboard.isDown(key) then
                return true
            end
        end
    end
    
    -- Check joystick controls
    if self.activeJoystick then
        if action == "up" then
            return self.activeJoystick:getAxis(self.joystickConfig.moveVerticalAxis) < -self.joystickConfig.deadzone
        elseif action == "down" then
            return self.activeJoystick:getAxis(self.joystickConfig.moveVerticalAxis) > self.joystickConfig.deadzone
        elseif action == "left" then
            return self.activeJoystick:getAxis(self.joystickConfig.moveHorizontalAxis) < -self.joystickConfig.deadzone
        elseif action == "right" then
            return self.activeJoystick:getAxis(self.joystickConfig.moveHorizontalAxis) > self.joystickConfig.deadzone
        elseif action == "interact" then
            return self.activeJoystick:isDown(self.joystickConfig.interactButton)
        end
    end
    
    return false
end

function controls:getMovementVector()
    local x, y = 0, 0
    
    -- Keyboard movement
    if self:isDown("left") then x = x - 1 end
    if self:isDown("right") then x = x + 1 end
    if self:isDown("up") then y = y - 1 end
    if self:isDown("down") then y = y + 1 end
    
    -- Joystick movement (more precise analog values)
    if self.activeJoystick then
        local joyX = self.activeJoystick:getAxis(self.joystickConfig.moveHorizontalAxis)
        local joyY = self.activeJoystick:getAxis(self.joystickConfig.moveVerticalAxis)
        
        if math.abs(joyX) > self.joystickConfig.deadzone then
            x = joyX
        end
        if math.abs(joyY) > self.joystickConfig.deadzone then
            y = joyY
        end
    end
    
    return x, y
end

-- Joystick connection handlers
function controls:joystickAdded(joystick)
    if not self.activeJoystick then
        self.activeJoystick = joystick
    end
end

function controls:joystickRemoved(joystick)
    if self.activeJoystick == joystick then
        self.joysticks = love.joystick.getJoysticks()
        self.activeJoystick = self.joysticks[1]
    end
end

return controls 