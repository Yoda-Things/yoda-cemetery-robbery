Config = {}

Config.Locale = 'en'
Config.Framework = 'QB' -- ESX OR QB

Config.Target = 'QB' -- OX OR QB
Config.Notify = 'OX' -- OX OR QB
Config.Inventory = 'OX' -- OX OR QB
Config.dispatch = 'PS' -- PS OR ORIGEN

Config.typeOfRobbery = 'item'-- target or item 

Config.Camp = 70 -- Percentage to have a body on the camp
Config.Values = 70 -- Percentage for body values
Config.PoliceNotify = 60 -- Percentage to notify the police
Config.PoliceJob = 'police' -- Police Job
Config.minPolice = 0 -- Min police to rob a tomb

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

Config.peds = {
    ped1 = 'a_m_m_beach_02',
}

Config.robloc = {
    loc74 = vec3(-1740.2509, -298.0301, 48.4766),
    loc9 = vec3(-1794.6807, -269.9242, 44.7556),
    loc11 = vec3(-1792.3054, -272.6735, 44.9436),
    loc43 = vec3(-1756.8999, -284.2284, 47.4401),
    loc40 = vec3(-1757.4694, -278.9848, 47.5124),
    loc54 = vec3(-1749.0022, -290.9471, 48.3086),
    loc49 = vec3(-1753.4692, -295.2139, 47.2835),
    loc66 = vec3(-1747.4573, -281.7064, 48.8186),
    loc27 = vec3(-1761.2556, -300.0404, 46.4696),
    loc1 = vec3(-1806.4670, -260.2537, 43.6576),
    loc70 = vec3(-1745.1486, -292.5400, 48.2772),
    loc7 = vec3(-1797.3826, -267.6638, 44.6046),
    loc44 = vec3(-1756.3542, -286.4593, 47.4115),
    loc37 = vec3(-1759.9442, -285.3122, 46.9454),
    loc59 = vec3(-1751.4904, -281.6229, 48.6794),
    loc72 = vec3(-1744.0175, -296.4910, 48.0646),
    loc45 = vec3(-1755.7230, -288.0844, 47.3752),
    loc5 = vec3(-1800.8870, -265.1422, 44.2742),
    loc58 = vec3(-1751.0804, -282.9284, 48.6455),
    loc10 = vec3(-1793.5529, -271.1597, 44.8376),
    loc30 = vec3(-1756.1779, -304.7162, 46.9019),
    loc75 = vec3(-1740.1931, -295.5301, 48.6313),
    loc55 = vec3(-1749.2212, -290.0266, 48.3467),
    loc67 = vec3(-1746.9636, -283.5310, 48.7574),
    loc12 = vec3(-1791.0736, -274.0713, 45.0369),
    loc29 = vec3(-1758.3856, -303.2084, 46.7082),
    loc6 = vec3(-1798.9934, -266.1691, 44.4250),
    loc39 = vec3(-1761.1641, -279.6887, 46.9848),
    loc18 = vec3(-1775.9259, -285.5022, 45.9202),
    loc4 = vec3(-1802.7462, -263.1397, 44.0960),
    loc60 = vec3(-1752.1096, -279.3814, 48.7533),
    loc14 = vec3(-1784.1173, -278.2318, 45.4887),
    loc48 = vec3(-1754.1292, -293.0570, 47.2577),
    loc52 = vec3(-1748.2972, -295.0417, 48.1119),
    loc21 = vec3(-1771.2092, -288.9741, 45.8264),
    loc46 = vec3(-1755.4333, -289.4067, 47.3349),
    loc17 = vec3(-1777.8179, -283.9919, 45.8845),
    loc42 = vec3(-1757.1013, -281.7690, 47.4838),
    loc68 = vec3(-1745.9150, -289.8879, 48.4245),
    loc3 = vec3(-1804.4088, -262.3982, 43.9284),
    loc20 = vec3(-1773.5791, -287.5646, 45.8513),
    loc22 = vec3(-1769.5859, -290.8812, 45.9203),
    loc65 = vec3(-1748.2456, -279.5142, 48.8855),
    loc24 = vec3(-1767.4938, -293.0032, 46.0487),
    loc13 = vec3(-1789.1453, -275.0585, 45.1681),
    loc28 = vec3(-1760.4124, -302.0581, 46.5262),
    loc47 = vec3(-1754.7203, -291.0390, 47.3230),
    loc56 = vec3(-1749.4202, -288.4507, 48.4371),
    loc64 = vec3(-1748.7069, -277.4785, 48.9210),
    loc34 = vec3(-1749.1152, -309.4139, 47.3045),
    loc19 = vec3(-1774.7697, -286.3979, 45.8928),
    loc23 = vec3(-1768.6237, -292.0236, 45.9811),
    loc26 = vec3(-1762.1631, -299.1257, 46.4024),
    loc51 = vec3(-1747.9271, -296.2740, 48.0155),
    loc71 = vec3(-1744.6593, -294.2546, 48.1797),
    loc63 = vec3(-1749.8287, -275.1210, 48.9216),
    loc33 = vec3(-1750.6979, -308.2186, 47.1725),
    loc15 = vec3(-1780.7633, -281.0662, 45.7852),
    loc25 = vec3(-1763.1406, -297.8685, 46.3236),
    loc50 = vec3(-1747.2981, -299.1766, 47.8255),
    loc38 = vec3(-1760.9725, -281.5771, 47.0337),
    loc2 = vec3(-1805.3055, -261.3748, 43.8079),
    loc53 = vec3(-1748.6105, -293.5456, 48.1973),
    loc32 = vec3(-1752.1663, -307.7906, 47.1140),
    loc35 = vec3(-1759.1328, -288.1112, 46.8397),
    loc16 = vec3(-1779.0042, -282.8546, 45.8491),
    loc69 = vec3(-1745.3710, -291.2845, 48.3471),
    loc62 = vec3(-1752.6713, -276.4101, 48.5916),
    loc73 = vec3(-1743.5203, -298.3990, 47.9708),
    loc31 = vec3(-1754.7855, -305.9962, 46.9927),
    loc36 = vec3(-1759.5671, -286.9658, 46.8670),
    loc61 = vec3(-1752.3649, -277.9043, 48.6719),
    loc41 = vec3(-1757.2100, -280.5007, 47.5016),
    loc8 = vec3(-1796.0380, -268.7952, 44.6839),
    loc57 = vec3(-1750.8992, -284.2415, 48.6048),
    loc78 = vec3(-1739.7898, -294.0413, 48.7213),
    loc77 = vec3(-1739.9053, -292.7033, 48.8138),
    loc76 = vec3(-1739.7898, -294.0413, 48.7213),
    loc79 = vec3(-1740.3054, -290.1725, 48.9940),
    loc81 = vec3(-1740.3054, -290.1725, 48.9940),
    loc80 = vec3(-1733.1591, -275.1713, 50.8120),
    loc82 = vec3(-1740.3054, -290.1725, 48.9940),
    loc83 = vec3(-1733.1591, -275.1713, 50.8120),
    loc84 = vec3(-1780.2457, -266.4345, 45.9770),
}