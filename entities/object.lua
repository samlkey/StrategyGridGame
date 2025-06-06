local class = require("module/class")
local sprite = require("module/sprite")
local collision_box = require("module/collision_box")
local object = class:extend("object")

function object:new(x, y, size)
    self.x = x
    self.y = y
    self.size = size
    self.sprite = sprite(x, y, self.size, self.size, "assets/object.png")
    self.collision_box = collision_box(x, y, self.size, self.size, 1)
end

function object:draw()
    self.sprite:draw()

    -- Draw debug rectangle if in debug mode
    if DEBUG then
        love.graphics.rectangle("line", self.x, self.y, self.size, self.size)
        self.collision_box:draw()
    end
end

return object
