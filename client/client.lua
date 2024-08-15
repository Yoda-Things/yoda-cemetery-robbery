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
    local ped = CreateRandomPed(loc.x, loc.y, loc.z)
    ApplyPedBlood(ped, 3, 0.0, 0.0, 0.0, "wound_sheet")
    IsPedDeadOrDying(ped, false)
end)