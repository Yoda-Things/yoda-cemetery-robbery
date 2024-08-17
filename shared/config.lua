Config = {}

Config.Locale = 'en'
Config.Framework = 'QB' -- ESX OR QB

Config.Target = 'QB' -- OX OR QB
Config.Notify = 'QB' -- OX OR QB
Config.Inventory = 'QB' -- OX OR QB

Config.Camp = 70 -- Percentage to have a body on the camp
Config.Values = 70 -- Percentage for body values
Config.PoliceNotify = 60 -- Percentage to notify the police
Config.PoliceJob = 'police' -- Police Job

Config.CheckEvidenceCoords = vec3(446.7606, -974.2661, 30.4386) -- Coords for target to check Evidence


Config.Items = {
    i1 = {
        item = 'cash',
        min = 10,
        max = 100,
    },
    i2 = {
        item = 'diamond_necklace',
        min = 3,
        max = 10,
    },
    i3 = {
        item = 'goldchain',
        min = 3,
        max = 10,
    },
    i4 = {
        item = 'diamond_ring_silver',
        min = 3,
        max = 10,
    },
    i5 = {
        item = 'silver_ring',
        min = 3,
        max = 10,
    }
}

Config.robloc = {
    loc1 = vec3(-1765.0946, -211.6655, 55.1037),
    loc2 = vec3(-1766.4816, -209.9521, 54.9043),
}

Config.peds = {
    ped1 = 'a_m_m_beach_02',
}