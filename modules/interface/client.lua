
local logger = require("modules.utility.shared.logger")

local interface = {
    store = {
        visible = false,
        loaded = false
    }
}
interface.__index = interface

function interface.new()
    local self = setmetatable({}, interface)
    self:registerCallbacks()
    return self
end

function interface:toggle(state)
    self.store.visible = state
    
    SendNUIMessage({
        type = 'setVisible',
        data = state
    })
    
    if state then
        local config = require("shared.config")
        SendNUIMessage({
            type = 'setPaths',
            data = config.Paths
        })
    end
    
    SetNuiFocus(state, state)
    logger:info("Interface toggled:", state)
end

function interface:registerCallbacks()
    RegisterNUICallback('APP_LOADED', function(_, cb)
        self.store.loaded = true
        logger:success("NUI Application loaded")
        cb({})
    end)

    RegisterNUICallback('exitNUI', function(_, cb)
        self:toggle(false)
        cb({})
    end)

    RegisterNUICallback('beginJourney', function(data, cb)
        local PathManager = require("modules.paths.client")
        local success, message = PathManager:selectPath(data.pathId)
        
        if success then
            self:toggle(false)
        end
        
        cb({
            success = success,
            message = message
        })
    end)
end

return interface.new()