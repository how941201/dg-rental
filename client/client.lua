local QBCore = exports['qb-core']:GetCoreObject()
local RentedCars = {}

CreateThread(function()
    Wait(1000)
    for k,v in pairs(Config.Rentals) do
        RequestModel(GetHashKey(v.pedhash))
        while not HasModelLoaded(GetHashKey(v.pedhash)) do
            Wait(1)
        end
        created_ped = CreatePed(5, GetHashKey(v.pedhash) , v.spawnpoint.x, v.spawnpoint.y, (v.spawnpoint.z-1), v.spawnpoint.w, false, true)
        FreezeEntityPosition(created_ped, true)
        SetEntityInvincible(created_ped, true)
        SetBlockingOfNonTemporaryEvents(created_ped, true)
        TaskStartScenarioInPlace(created_ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)
        exports['qb-target']:AddTargetEntity(created_ped, {
            options = {
                {
                    rentid = k,
                    type = "client",
                    event = "dg-rental:client:startrent",
                    icon = v.icon,
                    label = v.title,
                    vehicledata = Config.VehicleList[v.vehiclelist],
                    carspawn = v.carspawn
                },
            },
            distance = 3.0
        })
        --
        local blip = AddBlipForCoord(vector4(v.spawnpoint.x, v.spawnpoint.y, (v.spawnpoint.z-1), v.spawnpoint.w))
        SetBlipSprite(blip, 147)
        SetBlipScale(blip, 0.9)
        SetBlipColour(blip, 3)
        SetBlipDisplay(blip, 4)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Lang:t('bilp.lable'))
        EndTextCommandSetBlipName(blip)
    end
end)

RegisterNetEvent('dg-rental:client:startrent', function(data)
    local sendmenu =  {}
    table.insert(sendmenu, { header = data.label, isMenuHeader = true })

    local idi = 2
    for k,v in pairs(data.vehicledata) do
        table.insert(sendmenu, {
            id = idi,
            header = v.name,
            txt = v.price .. " $",
            params = {
                event = "dg-rental:client:selectduration",
                args = {
                    rentid = data.rentid,
                    vehdata = v,
                    carspawn = data.carspawn
                }
            }
        })
        idi = idi + 1
    end

    exports['qb-menu']:openMenu(sendmenu)
end)

RegisterNetEvent('dg-rental:client:selectduration', function(data)
    local durationMenu = {
        { header = Lang:t('menu.rent_time_title'), isMenuHeader = true },
        {
            header = "1 " ..Lang:t('menu.day'),
            txt = Lang:t('menu.rent').." 1 "..Lang:t('menu.day'),
            params = {
                event = "dg-rental:client:rentcar",
                args = {
                    rentid = data.rentid,
                    vehdata = data.vehdata,
                    carspawn = data.carspawn,
                    duration = 1
                }
            }
        },
        {
            header = "3 " ..Lang:t('menu.day'),
            txt = Lang:t('menu.rent').." 3 "..Lang:t('menu.day'),
            params = {
                event = "dg-rental:client:rentcar",
                args = {
                    rentid = data.rentid,
                    vehdata = data.vehdata,
                    carspawn = data.carspawn,
                    duration = 3
                }
            }
        },
        {
            header = "7 " ..Lang:t('menu.day'),
            txt = Lang:t('menu.rent').." 7 "..Lang:t('menu.day'),
            params = {
                event = "dg-rental:client:rentcar",
                args = {
                    rentid = data.rentid,
                    vehdata = data.vehdata,
                    carspawn = data.carspawn,
                    duration = 7
                }
            }
        },
        {
            header = "14 " ..Lang:t('menu.day'),
            txt = Lang:t('menu.rent').." 14 "..Lang:t('menu.day'),
            params = {
                event = "dg-rental:client:rentcar",
                args = {
                    rentid = data.rentid,
                    vehdata = data.vehdata,
                    carspawn = data.carspawn,
                    duration = 14
                }
            }
        },
        {
            header = "30 " ..Lang:t('menu.day'),
            txt = Lang:t('menu.rent').." 30 "..Lang:t('menu.day'),
            params = {
                event = "dg-rental:client:rentcar",
                args = {
                    rentid = data.rentid,
                    vehdata = data.vehdata,
                    carspawn = data.carspawn,
                    duration = 30
                }
            }
        },
    }

    exports['qb-menu']:openMenu(durationMenu)
end)


RegisterNetEvent('dg-rental:client:rentcar', function(data)
    TriggerServerEvent('dg-rental:server:rentcar', data)
end)

RegisterNetEvent('dg-rental:client:setupvehicle', function(vehicle_sv_id)
    local veh = NetworkGetEntityFromNetworkId(vehicle_sv_id)
    table.insert(RentedCars, vehicle_sv_id)
    exports['LegacyFuel']:SetFuel(veh, 100)
end)
