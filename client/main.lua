local TARGET = Config.Target
local locInfos = false
local inRob = false
local FRAMEWORK = Config.Framework

local ESX, QB
if FRAMEWORK == 'ESX' then
    ESX = exports["es_extended"]:getSharedObject()
else
    QB = exports["qb-core"]:GetCoreObject()
end

if FRAMEWORK == 'QB' then
    playerJob = QB.Functions.GetPlayerData().job
end

local evidenceAnalysisCoords = Config.CheckEvidenceCoords

Citizen.CreateThread(function ()
    if playerJob and playerJob.name == Config.PoliceJob then
        if TARGET == 'OX' then
            exports.ox_target:addSphereZone({
                coords = evidenceAnalysisCoords,
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
            exports['qb-target']:AddCircleZone('analyzeEvidence', evidenceAnalysisCoords, 2.0, {
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
    end
end)


RegisterNetEvent('yoda-cemeteryrob:startRob', function ()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped, false)

    if not locInfos then
        TriggerServerEvent('yoda-cemeteryrob:randomLocInfos')
    end

    for _, loc in pairs(Config.robloc) do
        local dist = #(loc.xy - pos.xy)
        if dist < 1 then
            TriggerServerEvent('yoda-cemeteryrob:searchLocInfo', loc)
        end
    end
end)

RegisterNetEvent('yoda-cemeteryrob:startDigging', function (loc, bodyinfo)
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

    if not bodyinfo then
        TriggerClientEvent('yoda-cemeteryrob:noBodysFound', source)
    elseif not inRob then 
        inRob = true
        TriggerEvent('yoda-cemeteryrob:spawnPed', loc)
    end

    TriggerEvent('yoda-cemeteryrob:notifyPolice', loc)
end)

RegisterNetEvent('yoda-cemeteryrob:spawnPed', function(loc)
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
        TriggerEvent('yoda-cemeteryrob:createTarget', ped, loc)
    end
end)

RegisterNetEvent('yoda-cemeteryrob:createTarget', function (ped, loc)
    if DoesEntityExist(ped) then
        if TARGET == 'OX' then
            target1 = exports.ox_target:addSphereZone({
                coords = vector3(loc.x, loc.y, loc.z - 1),
                radius = 2.0,
                options = {
                    name = 'yoda-cemeteryrob:targetToRob',
                    icon = 'fas fa-user',
                    label = _t('target.rob'),
                    onSelect = function ()
                        TriggerEvent('yoda-cemeteryrob:playSearchAnim', source, ped, loc)
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
                            TriggerEvent('yoda-cemeteryrob:playSearchAnim', source, ped, loc)
                        end,
                        icon = "fas fa-user",
                        label = _t('target.rob'),
                    }
                },
                distance = 2.0
            })
        end
    else
        print('Ped entity does not exist, cannot create target.')
    end
end)

RegisterNetEvent('yoda-cemeteryrob:deleteTarget', function (ped, loc)
    if TARGET == 'OX' then
        exports.ox_target:removeZone(target1)
    else
        exports['qb-target']:RemoveZone("targetrob")
    end
    TriggerServerEvent('yoda-cemeteryrob:createEvidence', ped, loc, playerJob)
    inRob = false
end)

RegisterNetEvent('yoda-cemeteryrob:notifyPolice', function(loc)
    local percentage = Config.PoliceNotify * 0.01
    local chance = math.random()
    if chance <= percentage then
        exports["ps-dispatch"]:CustomAlert({
            coords = vector3(loc.x, loc.y, loc.z),
            message = "Criminal Activity - Camp Robbery",
            dispatchCode = "10-4 Camp Robbery",
            description = "Camp Robbery",
            radius = 0,
            sprite = 64,
            color = 2,
            scale = 1.0,
            length = 3,
        })
    end
end)

RegisterNetEvent('yoda-cemeteryrob:createTargetEvidence', function (ped, loc, assailantName)
    if DoesEntityExist(ped) and assailantName then
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
        end
    else
        print('Ped entity does not exist, cannot create target.')
    end
end)

RegisterNetEvent('yoda-cemeteryrob:playSearchAnim')
AddEventHandler('yoda-cemeteryrob:playSearchAnim', function(ped, loc)
    local playerPed = PlayerPedId()

    RequestAnimDict('amb@medic@standing@kneel@base')
    while not HasAnimDictLoaded('amb@medic@standing@kneel@base') do
        Wait(0)
    end

    TaskPlayAnim(playerPed, 'amb@medic@standing@kneel@base', 'base', 8.0, -8.0, 5000, 1, 0, false, false, false)
    Wait(5000)

    ClearPedTasks(playerPed)

    TriggerServerEvent('yoda-cemeteryrob:robResult', ped, loc)
end)