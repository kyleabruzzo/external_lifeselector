if not IsDuplicityVersion() then
    local config = require("shared.config")
    local logger = require("modules.utility.shared.logger")
    local PathManager = require("modules.paths.client")
    local interface = require("modules.interface.client")

    logger:info("Initializing Life Selector client...")

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
    local Bridge = require("modules.utility.shared.bridge")
    local Manager = require("modules.pathmanager.server")
    local VersionChecker = require("modules.utility.shared.versioncheck")

    logger:info("Initializing Life Selector server...")

    VersionChecker.checkVersion()

    if not Bridge then
        logger:error("Failed to load Bridge")
        return
    end

    Bridge.setupFramework()
    local detectedFramework = Bridge.getFrameworkName()
    local detectedInventory = Bridge.getInventoryName()

    if detectedFramework then
        logger:success("Framework detected:", string.upper(detectedFramework))
    else
        logger:error("No supported framework detected! (ESX/QB-Core/QBox/ND-Core)")
        return
    end

    if detectedInventory then
        logger:success("Detected inventory:", string.upper(detectedInventory))
    else
        logger:error("No supported inventory detected! (OX/QB/QS)")
        return
    end

    if not Manager then
        logger:error("Failed to load Manager")
        return
    end
    logger:success("Life Selector server initialized successfully")
end)