local TARGET = Config.Target

RegisterNetEvent('yoda-cemeteryrob:startRob', function ()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped, false)

    local dist = GetDistanceBetweenCoords(0.0, 0.0, 0.0, 5.0, 5.0, 5.0, true)
    for _, loc in pairs(Config.robloc) do
        local dist = #(loc.xy - pos.xy)
        if dist < 1 then
            TriggerServerEvent('yoda-cemeteryrob:searchLocInfo', loc)
        end
    end
end)

RegisterNetEvent('yoda-cemeteryrob:startDigging', function (loc)
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
end)

RegisterNetEvent('yoda-cemeteryrob:spawnPed', function (loc)
    local model = GetHashKey('a_m_m_beach_02')

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    local _, groundZ = GetGroundZFor_3dCoord(loc.x, loc.y, loc.z, true)
    local offsetZ = 1.0

    local ped = CreatePed(25, model, loc.x, loc.y, groundZ + offsetZ, 124.8383, true, true)

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
            exports.ox_target:addSphereZone({
                coords = vector3(loc.x, loc.y, loc.z - 1),
                radius = 2.0,
                options = {
                    name = 'yoda-cemeteryrob:targetToRob',
                    icon = 'fas fa-user',
                    label = _t('target.rob'),
                    onSelect = function ()
                        TriggerServerEvent('yoda-cemeteryrob:robResult')
                    end
                }
            })
        else
            exports['qb-target']:AddCircleZone('targetRob', vector3(loc.x, loc.y, loc.z - 1), 2.0, {
                name = 'targetRob1',
                debugPoly = false,
                useZ = true}, {
                options = {
                    {
                        type = "server",
                        event = "yoda-cemeteryrob:robResult",
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

