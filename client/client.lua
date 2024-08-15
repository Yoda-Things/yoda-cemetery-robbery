RegisterNetEvent('yoda-cemeteryrob:startRob', function ()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped, false)

    local dist = GetDistanceBetweenCoords(0.0, 0.0, 0.0, 5.0, 5.0, 5.0, false)

    for key, loc in pairs(Config.robloc) do
        local dist = #(loc.xy - pos.xy)
        if dist < 1 then
            print(dist)
            TriggerEvent('yoda-cemeteryrob:startDigging', loc)
        end
    end
end)

RegisterNetEvent('yoda-cemeteryrob:startDigging', function (loc)
    local ped = PlayerPedId()
    
    RequestAnimDict('amb@world_human_gardener_plant@female@base')
    while 
        not HasAnimDictLoaded('amb@world_human_gardener_plant@female@base')
    do
        Wait(0)
    end
    TaskPlayAnim(ped, 'amb@world_human_gardener_plant@female@base', 'base_female', 8.0, 8.0, 10000, 1, 0, false, false, false)

    Wait(10000)

    local random = math.random(0, 1)

    TriggerEvent('yoda-cemeteryrob:spawnPed', loc)

    --[[ if random == 0 then
        print('Campa Vazia')
    else
        TriggerEvent('yoda-cemeteryrob:spawnPed', loc)
    end ]]
end)

RegisterNetEvent('yoda-cemeteryrob:spawnPed', function (loc)
    print('Ped Created')

    local model = GetHashKey('a_m_m_beach_02')

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    local ped = CreatePed(25 , model, loc.x , loc.y , loc.z, 124.8383, true, true)

    if DoesEntityExist(ped) then
        print('Ped creation successful')

        local animDict = "dead"
        local animName = "dead_a"

        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(0)
        end

        TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, 1, 0, false, false, false)

        ApplyPedDamagePack(ped, "BigHitByVehicle", 1.0, 1.0)
        SetEntityHealth(ped, 0)
        TaskStartScenarioAtPosition(ped, "WORLD_HUMAN_BUM_SLUMPED", loc.x, loc.y, loc.z, 0.0, -1, true, false) -- Mantém o ped deitado


    else
        print('Failed to create Ped')
    end
end)