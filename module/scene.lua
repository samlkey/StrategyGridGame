local class = require("module/class")
local scene = class:extend("scene")

function scene:new()
    -- Scene states
    self.SCENES = {
        MENU = "menu",
        OVERWORLD = "overworld",
        BATTLE = "battle",
        PAUSE = "pause"
    }

    -- Current scene state
    self.currentScene = self.SCENES.OVERWORLD
    
    -- Entities to render for each scene
    self.sceneEntities = {
        [self.SCENES.MENU] = {},
        [self.SCENES.OVERWORLD] = {},
        [self.SCENES.BATTLE] = {},
        [self.SCENES.PAUSE] = {}
    }
    
    -- UI elements for each scene
    self.sceneUI = {
        [self.SCENES.MENU] = {},
        [self.SCENES.OVERWORLD] = {},
        [self.SCENES.BATTLE] = {},
        [self.SCENES.PAUSE] = {}
    }

    -- Scene maps
    self.sceneMaps = {
        [self.SCENES.OVERWORLD] = overworld
    }
end

function scene:addEntity(entity, sceneName)
    if not sceneName then
        sceneName = self.currentScene
    end
    table.insert(self.sceneEntities[sceneName], entity)
end

function scene:removeEntity(entity, sceneName)
    if not sceneName then
        sceneName = self.currentScene
    end
    for i, e in ipairs(self.sceneEntities[sceneName]) do
        if e == entity then
            table.remove(self.sceneEntities[sceneName], i)
            break
        end
    end
end

function scene:clearScene(sceneName)
    if not sceneName then
        sceneName = self.currentScene
    end
    self.sceneEntities[sceneName] = {}
    self.sceneUI[sceneName] = {}
end

function scene:switchTo(sceneName)
    if self.SCENES[sceneName] then
        self.currentScene = self.SCENES[sceneName]
    end
end

function scene:getCurrentEntities()
    return self.sceneEntities[self.currentScene]
end

function scene:draw()
    -- Draw the map
    local map = self:getMap()
    if map then
        map:drawLayer(map.layers["Ground"])
        map:drawLayer(map.layers["Trees"])
    end

    -- Draw current scene's entities
    if self.currentScene == self.SCENES.BATTLE then
        -- Clear screen for battle scene
        love.graphics.clear()
        -- Draw battle grid if it exists
        if bGrid then
            bGrid:draw()
        end
    else
        -- Draw all entities in the current scene
        for _, entity in ipairs(self.sceneEntities[self.currentScene]) do
            entity:draw()
        end
    end
    
    -- Draw UI elements for current scene
    for _, ui in ipairs(self.sceneUI[self.currentScene]) do
        ui:draw()
    end
end

function scene:update(dt)
    -- Update all entities in current scene
    for _, entity in ipairs(self.sceneEntities[self.currentScene]) do
        if entity.update then
            entity:update(dt)
        end
    end
    
    -- Update UI elements
    for _, ui in ipairs(self.sceneUI[self.currentScene]) do
        if ui.update then
            ui:update(dt)
        end
    end
end

function scene:getMap()
    return self.sceneMaps[self.currentScene]
end

return scene
