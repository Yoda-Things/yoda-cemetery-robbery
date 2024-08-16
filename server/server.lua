Graves = {}

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    local n = 0
    body = false
    for _, loc in pairs(Config.robloc) do
        local chance = math.random()
        if chance <= 0.7 then
            body = true
        end
        n = n + 1 
        local grave = 'Grave' .. n
        Graves[grave] = {
            loc = loc,
            body = body,
            open = false,
        }
    end
end)

RegisterNetEvent('yoda-cemeteryrob:searchLocInfo')
AddEventHandler('yoda-cemeteryrob:searchLocInfo', function(loc)
    for _, grave in pairs(Graves) do
        if Graves[grave].loc == loc then
            bodyinfo = Graves[grave].body
            open = Graves[grave].open
        end
    end
    if bodyinfo and not open then
        TriggerClientEvent('yoda-cemeteryrob:startDigging', source, loc)
    elseif bodyinfo and open then
        TriggerClientEvent('yoda-cemeteryrob:graveOpen', source)
    else
        TriggerClientEvent('yoda-cemeteryrob:noBodysFound', source)
    end
end)

RegisterNetEvent('yoda-cemeteryrob:robResult')
AddEventHandler('yoda-cemeteryrob:robResult', function ()
    local random = math.random(0, 1)

    if random == 0 then
        TriggerClientEvent('yoda-cemeteryrob:bodyHasNoValues', source)
    else
        local items = {}
        for key, value in pairs(Config.Items) do
            table.insert(items, value)
        end

        local randomItem = items[math.random(1, #items)]

        local quantity = math.random(randomItem.min, randomItem.max)

        print(string.format('Recebeu %d de %s', quantity, randomItem.item))
    end
end)