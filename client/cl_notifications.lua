local NOTIFY = Config.Notify
if Config.Framework == 'QB' then
    QBCore = exports['qb-core']:GetCoreObject()
end

RegisterNetEvent('yoda-cemeteryrob:noBodysFound', function()
    if NOTIFY == 'OX' then
        exports.ox_lib:notify({description = _t('notifys.noBodysFound'),type = 'error'})
    else 
        QBCore.Functions.Notify(_t('notifys.noBodysFound'), 'error', 5000)
    end
end)

RegisterNetEvent('yoda-cemeteryrob:bodyHasNoValues', function()
    if NOTIFY == 'OX' then
        exports.ox_lib:notify({description = _t('notifys.bodyHasNoValues'),type = 'error'})
    else 
        QBCore.Functions.Notify(_t('notifys.bodyHasNoValues'), 'error', 5000)
    end
end)

RegisterNetEvent('yoda-cemeteryrob:graveOpen', function()
    if NOTIFY == 'OX' then
        exports.ox_lib:notify({description = _t('notifys.graveOpen'),type = 'error'})
    else 
        QBCore.Functions.Notify(_t('notifys.graveOpen'), 'error', 5000)
    end
end)

RegisterNetEvent('yoda-cemeteryrob:bloodEvidenceCollected', function()
    if NOTIFY == 'OX' then
        exports.ox_lib:notify({description = _t('notifys.bloodEvidenceCollected'),type = 'success'})
    else
        QBCore.Functions.Notify(_t('notifys.bloodEvidenceCollected'), 'success', 5000)
    end
end)

RegisterNetEvent('yoda-cemeteryrob:evidenceAnalyzed', function(assailantName)
    if assailantName then
        local message = _t('notifys.evidenceAnalyzed') .. assailantName
        if NOTIFY == 'OX' then
            exports.ox_lib:notify({description = message,type = 'success'})
        else
            QBCore.Functions.Notify(message, 'success', 5000)
        end
    else
        print("Error: assailantName is nil")
    end
end)

RegisterNetEvent('yoda-cemeteryrob:noEvidence', function()
    if NOTIFY == 'OX' then
        exports.ox_lib:notify({description = _t('notifys.noEvidence'),type = 'error'})
    else
        QBCore.Functions.Notify(_t('notifys.noEvidence'), 'error', 5000)
    end
end)

RegisterNetEvent('yoda-cemeteryrob:robStarted', function()
    if NOTIFY == 'OX' then
        exports.ox_lib:notify({description = _t('notifys.robStarted'),type = 'error'})
    else
        QBCore.Functions.Notify(_t('notifys.robStarted'), 'error', 5000)
    end
end)

RegisterNetEvent('yoda-cemeteryrob:notEnoughPolice', function()
    if NOTIFY == 'OX' then
        exports.ox_lib:notify({description = _t('notifys.notEnoughPolice'),type = 'error'})
    else
        QBCore.Functions.Notify(_t('notifys.notEnoughPolice'), 'error', 5000)
    end
end)

