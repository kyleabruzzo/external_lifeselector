local logger = require("modules.utility.shared.logger")

local PathManager = {}
PathManager.__index = PathManager

function PathManager.new()
    local self = setmetatable({}, PathManager)
    self.currentPath = nil
    logger:info("PathManager initialized")
    return self
end

function PathManager:GeneratePed(modelString, modelString2, playerId)
    logger:info("Generating MP Character:", modelString)
    
    RegisterEntityForCutscene(0, modelString, 3, GetEntityModel(playerId), 0)
    RegisterEntityForCutscene(playerId, modelString, 0, 0, 0)
    SetCutsceneEntityStreamingFlags(modelString, 0, 1) 

    local ped = RegisterEntityForCutscene(0, modelString2, 3, 0, 64)
    NetworkSetEntityInvisibleToNetwork(ped, true)
end

function PathManager:playCutscene(cutsceneData)
    logger:info("Starting cutscene sequence")
    
    local success, err = pcall(function()
        RequestCutscene(cutsceneData.name, 8)
        
        local timeout = 0
        while not HasCutsceneLoaded() and timeout < 1000 do 
            Wait(10)
            timeout = timeout + 10
        end
        
        if timeout >= 1000 then
            error("Cutscene load timeout")
        end
        
        NewLoadSceneStartSphere(
            cutsceneData.coords.x,
            cutsceneData.coords.y,
            cutsceneData.coords.z,
            1000, 0
        )

        local playerModel = GetEntityModel(PlayerPedId())
        local maleModel = GetHashKey("mp_m_freemode_01")
        local femaleModel = GetHashKey("mp_f_freemode_01")

        local cutsceneCharacter = "MP_1"
        if playerModel == femaleModel then
            cutsceneCharacter = "MP_2"
        end

        SetCutsceneEntityStreamingFlags(cutsceneCharacter, 0, 1)
        RegisterEntityForCutscene(PlayerPedId(), cutsceneCharacter, 0, 0, 64)

        SetWeatherTypeNow(cutsceneData.weather)
        StartCutscene(4)
        Wait(cutsceneData.duration)
        StopCutsceneImmediately()
    end)

    if not success then
        logger:error("Cutscene failed:", err)
        return false
    end

    return true
end


function PathManager:selectPath(pathId)
    local config = require("shared.config")
    local path = config.Paths[pathId]
    
    if not path then 
        logger:error("Invalid path selected:", pathId)
        return false, "Invalid path selected"
    end

    self.currentPath = path

    CreateThread(function()
        DoScreenFadeOut(config.Cutscene.fadeOutTime)
        Wait(config.Cutscene.fadeOutTime)

        local ped = PlayerPedId()
        SetEntityCoords(ped, 
            path.spawnLocation.x, 
            path.spawnLocation.y, 
            path.spawnLocation.z, 
            false, false, false, false)
        SetEntityHeading(ped, path.spawnLocation.w)

        NetworkOverrideClockTime(path.cutscene.time.hour, path.cutscene.time.minute, 0)
        Wait(config.Cutscene.prepareTime)
        DoScreenFadeIn(config.Cutscene.fadeInTime)
        
        if not self:playCutscene(path.cutscene) then
            logger:error("Failed to play cutscene for path:", pathId)
            DoScreenFadeIn(1000)
            return
        end

        for _, item in ipairs(path.items) do
            logger:info("Giving item:", item.name, "Amount:", item.amount)
        end
        TriggerServerEvent("pathmanager:giveItems", path.items)
    end)

    return true, "Path selected successfully"
end

function PathManager:getAvailablePaths()
    local config = require("shared.config")
    return config.Paths
end

function PathManager:getCurrentPath()
    return self.currentPath
end

return PathManager