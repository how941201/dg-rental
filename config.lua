Config = {}

Config.Rentals = {
    [0] = {
        id = "normal_01",
        pedhash = "a_m_y_business_03",
        title = "Normal Vehicle Rental",
        icon = "fas fa-box-circle-check",
        spawnpoint = vector4(-1035.24, -2751.17, 14.6, 333.36),
        carspawns = {
            [1] = vector4(vector4(-1018.06, -2731.95, 13.33, 239.26)),
        },
        vehiclelist = "vehlist01"
    },
}

Config.VehicleList = {
    ["vehlist01"] = {
        [0] = {
            name = "丁卡環狀 SJ 【2人轎車】",
            model = "kanjosj",
            price = 1000,
        },
        [1] = {
            name = "威皮 阿留申 【4人休旅車】",
            model = "aleutian",
            price = 2500,
        },
        [2] = {
            name = "卡林 維瓦尼特 【4人麵包車】",
            model = "vivanite",
            price = 3000,
        },

    },
}

Config.rentlocaltion = vector4(-1035.24, -2751.17, 14.6, 333.36)