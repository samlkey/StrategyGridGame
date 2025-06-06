local class = require("module/class")
local grid = class:extend("grid")

function grid:new(gridCells, cellSize, gridOriginX, gridOriginY)
    -- Grid centers table
    self.gridCenters = {}

    self.gridCells = gridCells
    self.cellSize = cellSize
    self.gridOriginX = gridOriginX
    self.gridOriginY = gridOriginY
    self.gridSize = gridCells * cellSize
end

function grid:draw()
    love.graphics.setColor(1, 1, 1)
    -- Vertical lines
    for i = 0, self.gridCells do
        local x = self.gridOriginX + i * self.cellSize
        love.graphics.line(x, self.gridOriginY, x, self.gridOriginY + self.gridSize)
    end

    -- Horizontal lines
    for i = 0, self.gridCells do
        local y = self.gridOriginY + i * self.cellSize
        love.graphics.line(self.gridOriginX, y, self.gridOriginX + self.gridSize, y)
    end

    -- Draw grid centers    
    self.gridCenters = self:getGridCenters()

    for i = 1, #self.gridCenters do
        love.graphics.circle("fill", self.gridCenters[i].x, self.gridCenters[i].y, 5)
    end
end

function grid:getGridCenters()
    local centers = {}
    for i = 0, self.gridCells - 1 do
        for j = 0, self.gridCells - 1 do
            local x = self.gridOriginX + (i + 0.5) * self.cellSize
            local y = self.gridOriginY + (j + 0.5) * self.cellSize
            table.insert(centers, {x = x, y = y})
        end
    end
    return centers
end

return grid