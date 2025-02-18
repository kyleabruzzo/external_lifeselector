if not IsDuplicityVersion() then
    local config = require("shared.config")
    local logger = require("modules.utility.shared.logger")
    local PathManager = require("modules.paths.client")
    local interface = require("modules.interface.client")

    logger:info("Initializing Life Selector...")

    PathManager.new()

    if config.Debug.enabled then
        RegisterCommand(config.Debug.command, function()
            interface:toggle(true)
            logger:info("Debug command used to show life selector")
        end)

        RegisterCommand('playcutscene', function(source, args)
            if not args[1] then return end
            RequestCutscene(args[1], 8)
            while not HasCutsceneLoaded() do Wait(10) end
            StartCutscene(0)
            while GetCutsceneTime() < GetCutsceneTotalDuration() do Wait(10) end
            RemoveCutscene()
        end, false)
        RegisterCommand("stopcut", function()
            StopCutsceneImmediately()
        end)
        
    end

    exports("showLifeSelector", function()
        interface:toggle(true)
        logger:info("Export used to show life selector")
    end)

    logger:success("Life Selector client initialized successfully")
    return
end

CreateThread(function()
    local logger = require("modules.utility.shared.logger")
    local InventoryManager = require("modules.inventory.server")
    if not InventoryManager then
        logger:error("Failed to load InventoryManager")
        return
    end
    logger:success("Life Selector server initialized successfully")
end)

