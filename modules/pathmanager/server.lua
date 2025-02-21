local logger = require("modules.utility.shared.logger")
local bridge = require("modules.utility.shared.bridge")

local InventoryManager = {}

RegisterNetEvent("pathmanager:initializePath", function(pathData)
    local src = source

    if not pathData then
        logger:error("Invalid path data received from player:", src)
        return
    end

    if pathData.setJob and pathData.setJob.enabled then
        local success = bridge.setJob(src, pathData.setJob.job, pathData.setJob.grade)
        if success then
            logger:info("Set job", pathData.setJob.job, "grade", pathData.setJob.grade, "for player:", src)
        else
            logger:error("Failed to set job for player:", src)
        end
    end

    if pathData.items then
        for _, item in ipairs(pathData.items) do
            local success = bridge.addItem(src, item.name, item.amount, item.metadata)
            if success then
                logger:info("Gave", item.amount, item.name, "to player:", src)
            else
                logger:error("Failed to give", item.name, "to player:", src)
            end
        end
    end
end)


logger:success("Inventory Manager initialized successfully")

return InventoryManager