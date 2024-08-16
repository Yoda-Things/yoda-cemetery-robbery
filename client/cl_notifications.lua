local NOTIFY = Config.Notify
QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('yoda-cemeteryrob:noBodysFound', function()
    if NOTIFY == 'OX' then
        exports.ox_lib:notify(_t('notifys.noBodysFound'), 'error', 5000)
    else 
        QBCore.Functions.Notify(_t('notifys.noBodysFound'), 'error', 5000)
    end
end)

RegisterNetEvent('yoda-cemeteryrob:bodyHasNoValues', function()
    if NOTIFY == 'OX' then
        exports.ox_lib:notify(_t('notifys.bodyHasNoValues'), 'error', 5000)
    else 
        QBCore.Functions.Notify(_t('notifys.bodyHasNoValues'), 'error', 5000)
    end
end)

RegisterNetEvent('yoda-cemeteryrob:graveOpen', function()
    if NOTIFY == 'OX' then
        exports.ox_lib:notify(_t('notifys.graveOpen'), 'error', 5000)
    else 
        QBCore.Functions.Notify(_t('notifys.graveOpen'), 'error', 5000)
    end
end)