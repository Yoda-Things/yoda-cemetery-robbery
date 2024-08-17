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

RegisterNetEvent('yoda-cemeteryrob:bloodEvidenceCollected', function()
    if NOTIFY == 'OX' then
        exports.ox_lib:notify(_t('notifys.bloodEvidenceCollected'), 'success', 5000)
    else
        QBCore.Functions.Notify(_t('notifys.bloodEvidenceCollected'), 'success', 5000)
    end
end)

RegisterNetEvent('yoda-cemeteryrob:evidenceAnalyzed', function(assailantName)
    if assailantName then
        local message = _t('notifys.evidenceAnalyzed') .. assailantName
        if NOTIFY == 'OX' then
            exports.ox_lib:notify(message, 'success', 5000)
        else
            QBCore.Functions.Notify(message, 'success', 5000)
        end
    else
        print("Error: assailantName is nil")
    end
end)

RegisterNetEvent('yoda-cemeteryrob:noEvidence', function()
    if NOTIFY == 'OX' then
        exports.ox_lib:notify(_t('notifys.noEvidence'), 'error', 5000)
    else
        QBCore.Functions.Notify(_t('notifys.noEvidence'), 'error', 5000)
    end
end)
