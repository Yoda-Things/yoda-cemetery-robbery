-- main.lua

local TARGET = Config.Target
local locInfos = false
local inRob = false
local FRAMEWORK = Config.Framework
local activeRobs = {}
local target1 = nil
local target2 = nil
local evidenceTargets = {}
local currentTombs = {}
local isInteracting = {}

local coordsList = {}
local startIndex = 1

RegisterCommand('addcoord', function()
    TriggerServerEvent('yoda-cemeteryrob:requestLastIndex')
end, false)

RegisterNetEvent('yoda-cemeteryrob:setLastIndex')
AddEventHandler('yoda-cemeteryrob:setLastIndex', function(lastIndex)
    startIndex = lastIndex + 1
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    coordsList["loc" .. startIndex] = vector3(coords.x, coords.y, coords.z)
    startIndex = startIndex + 1
end)

RegisterCommand('closecoord', function()
    TriggerServerEvent('yoda-cemeteryrob:saveCoords', coordsList)
end, false)

local ESX, QB
if FRAMEWORK == 'ESX' then
    ESX = exports["es_extended"]:getSharedObject()
else
    QBCore = exports["qb-core"]:GetCoreObject()
end

if FRAMEWORK == 'QB' then
    playerJob = QBCore.Functions.GetPlayerData().job
end

local evidenceAnalysisCoords = Config.CheckEvidenceCoords

function ApplyEvidenceTargetsToPolice()
    TriggerServerEvent('yoda-cemeteryrob:sendPoliceTargets')
end

local function getPlayerData()
    local firstname, secondname
    if FRAMEWORK == 'ESX' then
        if ESX.PlayerData and ESX.PlayerData.firstName and ESX.PlayerData.lastName then
            firstname = ESX.PlayerData.firstName
            secondname = ESX.PlayerData.lastName
        else
            print("PlayerData not loaded.")
            return
        end
    else
        local PlayerData = QBCore.Functions.GetPlayerData()
        firstname = PlayerData.charinfo.firstname
        secondname = PlayerData.charinfo.lastname
    end

    assailantName = firstname .. " " .. secondname
end

if FRAMEWORK == 'QB' then
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        getPlayerData()
    end) 
    --getPlayerData()
elseif FRAMEWORK == 'ESX' then
    RegisterNetEvent('esx:playerLoaded', function()
        getPlayerData()
    end)
    --getPlayerData()
end

RegisterNetEvent('yoda-cemeteryrob:createPoliceTarget', function()
    if evidenceTargets['analyzeEvidence'] then
        if TARGET == 'OX' then
            if evidenceTargets['analyzeEvidence'] then
                exports.ox_target:removeZone(evidenceTargets['analyzeEvidence'])
            end
        else
            if evidenceTargets['analyzeEvidence'] then
                exports['qb-target']:RemoveZone(evidenceTargets['analyzeEvidence'])
            end
        end
    end

    if TARGET == 'OX' then
        evidenceTargets['analyzeEvidence'] = exports.ox_target:addSphereZone({
            coords = vector3(evidenceAnalysisCoords.x, evidenceAnalysisCoords.y, evidenceAnalysisCoords.z),
            radius = 2.0,
            options = {
                name = 'yoda-cemeteryrob:analyzeEvidence',
                icon = 'fas fa-microscope',
                label = _t('target.analyze_evidence'),
                onSelect = function ()
                    TriggerServerEvent('yoda-cemeteryrob:analyzeEvidence')
                end
            }
        })
    else
        evidenceTargets['analyzeEvidence'] = exports['qb-target']:AddCircleZone('analyzeEvidence', vector3(evidenceAnalysisCoords.x, evidenceAnalysisCoords.y, evidenceAnalysisCoords.z), 2.0, {
            name = 'analyzeEvidence',
            debugPoly = false,
            useZ = true}, {
            options = {
                {
                    action = function ()
                        TriggerServerEvent('yoda-cemeteryrob:analyzeEvidence')
                    end,
                    icon = "fas fa-microscope",
                    label = _t('target.analyze_evidence'),
                }
            },
            distance = 2.0
        })
    end
end)

Citizen.CreateThread(function ()
    TriggerServerEvent('yoda-cemeteryrob:randomLocInfos')
    ApplyEvidenceTargetsToPolice()
end)

RegisterNetEvent('yoda-cemeteryrob:locInfosGenerated')
AddEventHandler('yoda-cemeteryrob:locInfosGenerated', function(graves)
    gravesBackup = graves
    locInfos = true
    if Config.typeOfRobbery == 'target' then
        TriggerServerEvent('yoda-cemeteryrob:checkPoliceTarget', graves)
    end
end)

RegisterNetEvent('yoda-cemeteryrob:startRob', function (count, graves)
    print('rob event')
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped, false)
    local n = 0
    count = tonumber(count) or 0
    print('Count recebido (numérico):', count)

    if count >= Config.minPolice then
        if inRob then
            TriggerEvent('yoda-cemeteryrob:robStarted')
        else
            for _, grave in pairs(gravesBackup) do
                n = n + 1
                local loc = grave.loc
                print("Grave loc:", loc)

                if Config.typeOfRobbery == 'item' then
                    local dist = #(loc.xy - pos.xy)
                    if dist < 1 then
                        print("Distância até o túmulo:", dist)
                        if not locInfos then
                            TriggerServerEvent('yoda-cemeteryrob:randomLocInfos')
                        else
                            inRob = true
                            -- Passando 'n' como index
                            TriggerServerEvent('yoda-cemeteryrob:searchLocInfo', n, loc) 
                            break
                        end
                    end
                end
            end
        end
    else
        TriggerEvent('yoda-cemeteryrob:notEnoughPolice')
    end

    if Config.typeOfRobbery == 'target' then
        for _, grave in pairs(gravesBackup) do
            n = n + 1
            local loc = grave.loc
            if TARGET == 'OX' then
                local targetTomb = exports.ox_target:addSphereZone({
                    coords = vector3(loc.x, loc.y, loc.z - 1),
                    radius = 1.5,
                    options = {
                        name = 'yoda-cemeteryrob:targetToRob',
                        icon = 'fas fa-user',
                        label = 'Rob Tomb',
                        onSelect = function ()
                            if count >= Config.minPolice then
                                if not isInteracting[n] then
                                    inRob = true
                                    TriggerServerEvent('yoda-cemeteryrob:searchLocInfo', n, loc) -- Passando 'n' como index
                                end
                            else
                                TriggerEvent('yoda-cemeteryrob:notEnoughPolice')
                            end
                        end
                    }
                })
                currentTombs[n] = {target = targetTomb, coords = vector3(loc.x, loc.y, loc.z)}
                isInteracting[n] = false
            else
                local targetTomb = exports['qb-target']:AddCircleZone('targetrobTomb' .. n, vector3(loc.x, loc.y, loc.z - 1), 1.5, {
                    name = 'targetrobTomb' .. n,
                    debugPoly = false,
                    useZ = true
                }, {
                    options = {
                        {
                            action = function ()
                                if count >= Config.minPolice then
                                    if not isInteracting[n] then
                                        inRob = true
                                        TriggerServerEvent('yoda-cemeteryrob:searchLocInfo', n, loc) -- Passando 'n' como index
                                    end
                                else
                                    TriggerEvent('yoda-cemeteryrob:notEnoughPolice')
                                end
                            end,
                            icon = "fas fa-user",
                            label = 'Rob Tomb',
                        }
                    },
                    distance = 1.5
                })
                currentTombs[n] = {target = targetTomb, targetName = 'targetrobTomb' .. n, coords = vector3(loc.x, loc.y, loc.z)}
                isInteracting[n] = false
            end
        end
    end
end)

RegisterNetEvent('yoda-cemeteryrob:startDigging', function (index, loc, bodyinfo, grave)
    isInteracting[index] = true
    local ped = PlayerPedId()
    RequestAnimDict('amb@world_human_gardener_plant@male@base')
    while not HasAnimDictLoaded('amb@world_human_gardener_plant@male@base') do
        Wait(0)
    end

    local shovelModel = GetHashKey('prop_cs_trowel')
    RequestModel(shovelModel)
    while not HasModelLoaded(shovelModel) do
        Wait(0)
    end

    if not HasModelLoaded(shovelModel) then
        print("Modelo da pá não carregado.")
        return
    end

    local function removeTargetAndBlip(index)
        if currentTombs[index] then
            local tomb = currentTombs[index]

            if TARGET == 'OX' then
                if tomb.targetId then
                    exports.ox_target:removeZone(tomb.targetId)
                end
            else
                if tomb.targetName then
                    exports['qb-target']:RemoveZone(tomb.targetName)
                end
            end

            currentTombs[index] = nil
            isInteracting[index] = nil
        end
    end

    removeTargetAndBlip(index)

    local shovel = CreateObject(shovelModel, loc.x, loc.y, loc.z, true, true, false)
    AttachEntityToEntity(shovel, ped, GetPedBoneIndex(ped, 57005), 0.1, 0.0, 0.0, 0.0, 0.0, 100.0, true, true, false, true, 1, true)

    TaskPlayAnim(ped, 'amb@world_human_gardener_plant@male@base', 'base', 8.0, -8.0, 10000, 1, 0, false, false, false)
    local n = 0
    while n < 10 do
        Wait(1000)
        n = n + 1
        RequestNamedPtfxAsset("core")
        while not HasNamedPtfxAssetLoaded("core") do
            Wait(0)
        end
        UseParticleFxAssetNextCall("core")
        StartParticleFxNonLoopedOnEntity("ent_dst_rocks", shovel, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, false, false, false)
    end

    DeleteObject(shovel)
    SetModelAsNoLongerNeeded(shovelModel)

    if not activeRobs[loc] and bodyinfo then 
        activeRobs[loc] = true
        TriggerEvent('yoda-cemeteryrob:spawnPed', loc, grave)
    elseif not activeRobs[loc] and not bodyinfo then
        TriggerEvent('yoda-cemeteryrob:noBodysFound')
        inRob = false
    end

    TriggerEvent('yoda-cemeteryrob:notifyPolice', loc)
end)

RegisterNetEvent('yoda-cemeteryrob:spawnPed', function(loc, grave)
    local model = GetHashKey('a_m_m_beach_02')

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    local _, groundZ = GetGroundZFor_3dCoord(loc.x, loc.y, loc.z, true)
    local offsetZ = 1.0

    ped = CreatePed(25, model, loc.x, loc.y, groundZ + offsetZ, 124.8383, true, true)

    if DoesEntityExist(ped) then
        local animDict = "dead"
        local animName = "dead_a"

        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(0)
        end

        SetEntityCoordsNoOffset(ped, loc.x, loc.y, groundZ + offsetZ, true, true, true)
        FreezeEntityPosition(ped, true)
        SetEntityCollision(ped, false, false)
        SetPedCanRagdoll(ped, false)

        TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, 1, 0, false, false, false)
        ApplyPedDamagePack(ped, "BigHitByVehicle", 1.0, 1.0)
        SetEntityHealth(ped, 0)
        TaskStartScenarioAtPosition(ped, "WORLD_HUMAN_BUM_SLUMPED", loc.x, loc.y, groundZ + offsetZ, 0.0, -1, true, false)

        Wait(1000)

        FreezeEntityPosition(ped, true)
        SetEntityCollision(ped, false, false)
        TriggerEvent('yoda-cemeteryrob:createTarget', ped, loc, grave)
    end
end)

RegisterNetEvent('yoda-cemeteryrob:createTarget', function (ped, loc, grave)
    if TARGET == 'OX' then
        target1 = exports.ox_target:addSphereZone({
            coords = vector3(loc.x, loc.y, loc.z - 1),
            radius = 2.0,
            options = {
                name = 'yoda-cemeteryrob:targetToRob',
                icon = 'fas fa-user',
                label = _t('target.rob'),
                onSelect = function ()
                    TriggerEvent('yoda-cemeteryrob:playSearchAnim', source, ped, loc, grave)
                end
            }
        })
    else
        exports['qb-target']:AddCircleZone('targetrob', vector3(loc.x, loc.y, loc.z - 1), 2.0, {
            name = 'targetrob',
            debugPoly = false,
            useZ = true}, {
            options = {
                {
                    action = function ()
                        TriggerEvent('yoda-cemeteryrob:playSearchAnim', source, ped, loc, grave)
                    end,
                    icon = "fas fa-user",
                    label = _t('target.rob'),
                }
            },
            distance = 2.0
        })
    end
end)

RegisterNetEvent('yoda-cemeteryrob:deleteTarget', function (ped, loc, grave)
    if TARGET == 'OX' then
        exports.ox_target:removeZone(target1)
    else
        exports['qb-target']:RemoveZone("targetrob")
    end
    TriggerServerEvent('yoda-cemeteryrob:createTargetEvidenceServer', ped, loc, assailantName, grave)
    activeRobs[loc] = nil
    inRob = false
end)

RegisterNetEvent('yoda-cemeteryrob:notifyPolice', function(loc)
    local percentage = Config.PoliceNotify * 0.01
    local chance = math.random()
    if chance <= percentage then
        if Config.dispatch == 'PS' then
            exports["ps-dispatch"]:CustomAlert({
                coords = vector3(loc.x, loc.y, loc.z),
                message = "Criminal Activity - Tomb Robbery",
                dispatchCode = "10-4 Tomb Robbery",
                description = "Tomb Robbery",
                radius = 0,
                sprite = 64,
                color = 2,
                scale = 1.0,
                length = 3,
            })
        elseif Config.dispatch == 'ORIGEN' then
            exports['origen_police']:SendAlert({
                coords = vector3(loc.x, loc.y, loc.z),
                title = 'Tomb Robbery',
                type = 'GENERAL',
                message = 'Criminal Activity - Tomb Robbery',
                job = Config.PoliceJob,
            })
        end
    end
end)

RegisterNetEvent('yoda-cemeteryrob:createTargetEvidenceClient', function(ped, loc, assailantName)
    if target2 then
        if TARGET == 'OX' then
            exports.ox_target:removeZone(target2)
        else
            exports['qb-target']:RemoveZone('targetevidence')
        end
        target2 = nil
    end
    if TARGET == 'OX' then
        target2 = exports.ox_target:addSphereZone({
            coords = vector3(loc.x, loc.y, loc.z - 1),
            radius = 2.0,
            options = {
                name = 'yoda-cemeteryrob:createEvidence',
                icon = 'fas fa-user',
                label = _t('target.evidence'),
                onSelect = function ()
                    TriggerServerEvent('yoda-cemeteryrob:receiveEvidence', assailantName)
                end
            }
        })
    else
        exports['qb-target']:AddCircleZone('targetevidence', vector3(loc.x, loc.y, loc.z - 1), 2.0, {
            name = 'targetevidence',
            debugPoly = false,
            useZ = true}, {
            options = {
                {
                    action = function ()
                        TriggerServerEvent('yoda-cemeteryrob:receiveEvidence', assailantName)
                    end,
                    icon = "fas fa-user",
                    label = _t('target.evidence'),
                }
            },
            distance = 2.0
        })
        target2 = 'targetevidence'
    end
end)


RegisterNetEvent('yoda-cemeteryrob:playSearchAnim')
AddEventHandler('yoda-cemeteryrob:playSearchAnim', function(ped, loc, grave)
    local playerPed = PlayerPedId()

    RequestAnimDict('amb@medic@standing@kneel@base')
    while not HasAnimDictLoaded('amb@medic@standing@kneel@base') do
        Wait(0)
    end

    TaskPlayAnim(playerPed, 'amb@medic@standing@kneel@base', 'base', 8.0, -8.0, 5000, 1, 0, false, false, false)
    Wait(5000)

    ClearPedTasks(playerPed)

    TriggerServerEvent('yoda-cemeteryrob:robResult', ped, loc, grave)

end)

RegisterNetEvent('yoda-cemeteryrob:removeTargetAndPed', function(source, assailantName)
    if target1 then
        if TARGET == 'OX' then
            exports.ox_target:removeZone(target1)
        else
            exports['qb-target']:RemoveZone('targetrob')
        end
        target1 = nil
    end

    if target2 then
        if TARGET == 'OX' then
            exports.ox_target:removeZone(target2)
        else
            exports['qb-target']:RemoveZone('targetevidence')
        end
        target2 = nil
    end

    DeleteEntity(ped)
end)

RegisterNetEvent('yoda-cemeteryrob:checkPolice', function()
    TriggerServerEvent('yoda-cemeteryrob:checkPoliceServer')
end)