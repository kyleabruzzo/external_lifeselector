local logger = require("modules.utility.shared.logger")
local bridge = {
    framework = nil,
    frameworkObject = nil,
    inventory = nil
}

function bridge.setupFramework()
    if GetResourceState('ND_Core') == 'started' then
        bridge.framework = 'nd'
        bridge.frameworkObject = exports['ND_Core']
        
        if GetResourceState('ox_inventory') == 'started' then
            bridge.inventory = 'ox'
        end
    elseif GetResourceState('es_extended') == 'started' then
        bridge.framework = 'esx'
        bridge.frameworkObject = exports['es_extended']:getSharedObject()
        
        if GetResourceState('ox_inventory') == 'started' then
            bridge.inventory = 'ox'
        end
    elseif GetResourceState('qbx_core') == 'started' then
        bridge.framework = 'qbox'
        bridge.frameworkObject = exports.qbx_core
        
        if GetResourceState('ox_inventory') == 'started' then
            bridge.inventory = 'ox'
        end
    elseif GetResourceState('qb-core') == 'started' then
        bridge.framework = 'qbcore'
        bridge.frameworkObject = exports['qb-core']:GetCoreObject()
        
        if GetResourceState('qb-inventory') == 'started' then
            bridge.inventory = 'qb'
        end
    end

    if not bridge.inventory and GetResourceState('qs-inventory') == 'started' then
        bridge.inventory = 'qs'
    end
end

function bridge.getPlayer(source)
    if not bridge.framework then bridge.setupFramework() end
    
    if bridge.framework == 'nd' then
        return bridge.frameworkObject:getPlayer(source)
    elseif bridge.framework == 'esx' then
        return bridge.frameworkObject.GetPlayerFromId(source)
    elseif bridge.framework == 'qbcore' then
        return bridge.frameworkObject.Functions.GetPlayer(source)
    elseif bridge.framework == 'qbox' then
        return exports.qbx_core:GetPlayer(source)
    end
    return nil
end

function bridge.setJob(source, job, grade)
    local player = bridge.getPlayer(source)
    if not player then return false end
    
    if bridge.framework == 'nd' then
        return player.setJob(job, grade or 0)
    elseif bridge.framework == 'esx' then
        player.setJob(job, grade or 0)
        return true
    elseif bridge.framework == 'qbcore' then
        player.Functions.SetJob(job, grade or 0)
        return true
    elseif bridge.framework == 'qbox' then
        exports.qbx_core:SetJob(player, job, grade or 0)
        return true
    end
    return false
end

function bridge.getJob(source)
    local player = bridge.getPlayer(source)
    if not player then return nil end
    
    if bridge.framework == 'nd' then
        return player.getJob()
    elseif bridge.framework == 'esx' then
        return player.getJob()
    elseif bridge.framework == 'qbcore' or bridge.framework == 'qbox' then
        return player.PlayerData.job
    end
    return nil
end

function bridge.addItem(source, itemName, amount, metadata)
    if bridge.inventory == 'ox' then
        if metadata and next(metadata) then
            return exports.ox_inventory:AddItem(source, itemName, amount, metadata)
        end
        return exports.ox_inventory:AddItem(source, itemName, amount)
    elseif bridge.inventory == 'qs' then
        return exports['qs-inventory']:AddItem(source, itemName, amount, nil, metadata or {})
    end

    local player = bridge.getPlayer(source)
    if not player then return false end

    if bridge.framework == 'qbcore' then
        return player.Functions.AddItem(itemName, amount)
    elseif bridge.framework == 'qbox' then
        return exports.ox_inventory:AddItem(source, itemName, amount)
    end
    
    return false
end

function bridge.getFrameworkName()
    if not bridge.framework then bridge.setupFramework() end
    return bridge.framework
end

function bridge.getInventoryName()
    if not bridge.framework then bridge.setupFramework() end
    return bridge.inventory
end

logger:success("Bridge initialized successfully")


return bridge
