local Graves = {}
GraveRobbers = {}

local FRAMEWORK = Config.Framework

local ESX, QB
if FRAMEWORK == 'ESX' then
    ESX = exports["es_extended"]:getSharedObject()
else
    QBCore = exports["qb-core"]:GetCoreObject()
end

local function getLastIndexFromFile()
    local configFile = LoadResourceFile(GetCurrentResourceName(), "config2.lua")
    if not configFile then
        return 0
    end

    local lastIndex = 0
    for loc in string.gmatch(configFile, "loc(%d+)") do
        local num = tonumber(loc)
        if num and num > lastIndex then
            lastIndex = num
        end
    end

    return lastIndex
end

RegisterNetEvent('yoda-cemeteryrob:requestLastIndex')
AddEventHandler('yoda-cemeteryrob:requestLastIndex', function()
    local source = source
    local lastIndex = getLastIndexFromFile()
    TriggerClientEvent('yoda-cemeteryrob:setLastIndex', source, lastIndex)
end)

RegisterNetEvent('yoda-cemeteryrob:saveCoords')
AddEventHandler('yoda-cemeteryrob:saveCoords', function(coordsList)
    local configFile = LoadResourceFile(GetCurrentResourceName(), "config2.lua")

    if not configFile then
        configFile = "Config.robloc = {\n"
    else
        configFile = configFile:gsub("%}\n$", "")
    end

    for loc, coords in pairs(coordsList) do
        configFile = configFile .. string.format("    %s = vec3(%.4f, %.4f, %.4f),\n", loc, coords.x, coords.y, coords.z)
    end

    configFile = configFile .. "}\n"

    SaveResourceFile(GetCurrentResourceName(), "config2.lua", configFile, -1)
end)

RegisterNetEvent('yoda-cemeteryrob:randomLocInfos')
AddEventHandler('yoda-cemeteryrob:randomLocInfos', function()
    Graves = {}
    local percentage = Config.Camp * 0.01
    local n = 0
    local body = false
    for _, location in pairs(Config.robloc) do
        local chance = math.random()
        if chance <= percentage then
            body = true
        end
        n = n + 1 
        local grave = 'Grave' .. n
        Graves[grave] = {
            loc = location,
            body = body,
            open = false,
        }
    end
    TriggerClientEvent('yoda-cemeteryrob:locInfosGenerated', source)
end)

RegisterNetEvent('yoda-cemeteryrob:searchLocInfo')
AddEventHandler('yoda-cemeteryrob:searchLocInfo', function(loc)
    for _, grave in pairs(Graves) do
        if grave.loc == loc then
            local bodyinfo = grave.body
            local open = grave.open
            
            if open == false then
                TriggerClientEvent('yoda-cemeteryrob:startDigging', source, loc, bodyinfo, grave)
                Graves[grave] = {open = true}
            elseif open then
                TriggerClientEvent('yoda-cemeteryrob:graveOpen', source)
                return
            end
        end
    end
end)

RegisterNetEvent('yoda-cemeteryrob:robResult')
AddEventHandler('yoda-cemeteryrob:robResult', function (ped, loc, grave)
    local source = source
    local playerName

    if FRAMEWORK == 'ESX' then
        local xPlayer = ESX.GetPlayerFromId(source)
        playerName = xPlayer.getName()
    else
        local Player = QBCore.Functions.GetPlayer(source)
        playerName = Player.PlayerData.name
    end

    GraveRobbers[loc] = playerName 

    local percentage = Config.Values * 0.01
    local chance = math.random()
    if chance <= percentage then
        local items = {}
        for key, value in pairs(Config.Items) do
            table.insert(items, value)
        end

        local randomItem = items[math.random(1, #items)]
        local quantity = math.random(randomItem.min, randomItem.max)

        if Config.Inventory == 'OX' then
            exports.ox_inventory:AddItem(source, randomItem.item, quantity)
        else
            exports['qb-inventory']:AddItem(source, randomItem.item, quantity)
        end
        
    else
        TriggerClientEvent('yoda-cemeteryrob:bodyHasNoValues', source)
    end

    TriggerClientEvent('yoda-cemeteryrob:deleteTarget', source, ped, loc, grave)
end)

RegisterNetEvent('yoda-cemeteryrob:receiveEvidence')
AddEventHandler('yoda-cemeteryrob:receiveEvidence', function(assailantName)
    local source = source

    if Config.Inventory == 'OX' then
        exports.ox_inventory:AddItem(source, 'evidence', 1, {assailant = assailantName})
    else
        exports['qb-inventory']:AddItem(source, 'evidence', 1, {assailant = assailantName})
    end

    local players = (FRAMEWORK == 'QB') and QBCore.Functions.GetQBPlayers() or ESX.GetPlayers()

    for _, player in pairs(players) do
        local playerData = (FRAMEWORK == 'QB') and player.PlayerData or ESX.GetPlayerData(player)
        
        if playerData and playerData.job.name == Config.PoliceJob then
            TriggerClientEvent('yoda-cemeteryrob:removeTargetAndPed', -1, source, assailantName)
        end
    end
    
    TriggerClientEvent('yoda-cemeteryrob:bloodEvidenceCollected', source, assailantName)
end)

RegisterNetEvent('yoda-cemeteryrob:analyzeEvidence')
AddEventHandler('yoda-cemeteryrob:analyzeEvidence', function()
    local source = source
    local playerName = GetPlayerName(source)
    local hasEvidence = false
    local assailantName = nil

    if FRAMEWORK == 'ESX' then
        local xPlayer = ESX.GetPlayerFromId(source)
        local job = xPlayer.getJob()
        local inventory = xPlayer.getInventory()

        for _, item in pairs(inventory) do
            if item.name == 'evidence' and item.count > 0 then
                hasEvidence = true
                assailantName = item.info.assailant
                break
            end
        end

        if job.name == Config.PoliceJob then
            if hasEvidence then
                TriggerClientEvent('yoda-cemeteryrob:evidenceAnalyzed', source, assailantName)
            else
                TriggerClientEvent('yoda-cemeteryrob:noEvidence', source)
            end
        end

    else
        local Player = QBCore.Functions.GetPlayer(source)
        local job = Player.PlayerData.job
        local evidenceItem = Player.Functions.GetItemByName('evidence')

        if evidenceItem then
            hasEvidence = true
            assailantName = evidenceItem.info.assailant
        end

        if job.name == Config.PoliceJob then
            if hasEvidence then
                TriggerClientEvent('yoda-cemeteryrob:evidenceAnalyzed', source, assailantName)
            else
                TriggerClientEvent('yoda-cemeteryrob:noEvidence', source)
            end
        end
    end
end)

RegisterNetEvent('yoda-cemeteryrob:sendPoliceTargets')
AddEventHandler('yoda-cemeteryrob:sendPoliceTargets', function()
    local players = (FRAMEWORK == 'QB') and QBCore.Functions.GetQBPlayers() or ESX.GetPlayers()

    for _, player in pairs(players) do
        local playerData = (FRAMEWORK == 'QB') and player.PlayerData or ESX.GetPlayerData(player)
        
        if playerData and playerData.job.name == Config.PoliceJob then
            TriggerClientEvent('yoda-cemeteryrob:createPoliceTarget', player.PlayerData.source, evidenceAnalysisCoords)
        end
    end
end)

RegisterNetEvent('yoda-cemeteryrob:createTargetEvidenceServer')
AddEventHandler('yoda-cemeteryrob:createTargetEvidenceServer', function(ped, loc, assailantName, grave)
    local loc = grave

    local players = (FRAMEWORK == 'QB') and QBCore.Functions.GetQBPlayers() or ESX.GetPlayers()

    for _, player in pairs(players) do
        local playerData = (FRAMEWORK == 'QB') and player.PlayerData or ESX.GetPlayerData(player)

        if playerData and playerData.job.name == Config.PoliceJob then
            TriggerClientEvent('yoda-cemeteryrob:createTargetEvidenceClient', playerData.source, ped, loc, assailantName)
        end
    end
end)
