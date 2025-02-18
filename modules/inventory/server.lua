local logger = require("modules.utility.shared.logger")

local InventoryManager = {}

RegisterNetEvent("pathmanager:giveItems", function(items)
    local src = source

    if not items or type(items) ~= "table" then
        logger:error("Invalid item data received from player:", src)
        return
    end

    for _, item in ipairs(items) do
        local success = exports.ox_inventory:AddItem(src, item.name, item.amount)
        if success then
            logger:info("Gave", item.amount, item.name, "to player:", src)
        else
            logger:error("Failed to give", item.name, "to player:", src)
        end
    end
end)

logger:success("Inventory Manager initialized successfully")

return InventoryManager
