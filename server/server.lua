local QBCore = exports['qb-core']:GetCoreObject()
local RentedCars = {}
local VehicleSpots = {}
local InSpotLoop = false

-- Thread
CreateThread(function()
    while true do
        Wait(60000)
        local now = os.time()
        local result = MySQL.query.await('SELECT plate, rent FROM player_vehicles WHERE rent IS NOT NULL')

        for _, row in ipairs(result) do
            local plate = row.plate
            local expire = tonumber(row.rent)

            if now >= expire then
                for src, cars in pairs(RentedCars) do
                    for spot, car in pairs(cars) do
                        if GetVehicleNumberPlateText(car.veh) == plate then
                            DeleteEntity(car.veh)
                            VehicleSpots[car.rentid][car.carspot].used = false
                            table.remove(RentedCars[src], spot)
                            TriggerClientEvent('QBCore:Notify', src, Lang:t('error.time_up'), 'error')
                            break
                        end
                    end
                end
                MySQL.query('DELETE FROM player_vehicles WHERE plate = ?', { plate })
            end
        end
    end
end)



-- even
RegisterServerEvent('dg-rental:server:rentcar')
AddEventHandler('dg-rental:server:rentcar', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.money["cash"] >= data.vehdata.price then
        GetVehicleSpot(src, data)
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.not_enough_money'), "error")
    end
end)

-- function

function GetVehicleSpot(src, data)
    local Player = QBCore.Functions.GetPlayer(src)
    local foundspot = false

    if VehicleSpots[data.rentid] == nil then
        VehicleSpots[data.rentid] = {}
        for k,v in pairs(Config.Rentals[data.rentid].carspawns) do
            VehicleSpots[data.rentid][k] = {}           
            VehicleSpots[data.rentid][k].id = k
            VehicleSpots[data.rentid][k].coord = v
            VehicleSpots[data.rentid][k].used = false
            Wait(1)
        end
        Wait(1)
        if Player.Functions.RemoveMoney('cash', data.vehdata.price*data.duration) then
            foundspot = true
            VehicleSpots[data.rentid][1].used = true
            RentSpawnCar(src, data.vehdata.model, Config.Rentals[data.rentid].carspawns[1], data.vehdata.price, data.vehdata.returnprice, data.rentid, data.duration, 1)   
        
        end
    else
        local spot = 0
        for k,v in pairs(VehicleSpots[data.rentid]) do
            Wait(1)
            if v.used == false then
                foundspot = true
                spot = v.id
                break
            end
        end
        if spot ~= 0 and foundspot == true then
            if Player.Functions.RemoveMoney('cash', data.vehdata.price*data.duration) then
                
                VehicleSpots[data.rentid][spot].used = true
                RentSpawnCar(src, data.vehdata.model, Config.Rentals[data.rentid].carspawns[spot], data.vehdata.price, data.vehdata.returnprice, data.rentid, data.duration, spot)
            
            end
        end
    end
    if foundspot == false then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.nospotfound'), "error")
    end
end

function RentSpawnCar(src, model, carspawn, price, returnprice, rentid, duration, carspot)
    local veh = QBCore.Functions.SpawnVehicle(src, model, carspawn, true)
    local pData = QBCore.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    local expireTime = os.time() + (duration * 86400)

    Wait(100)
    SetEntityHeading(veh, carspawn.w)
    Wait(100)
    local netId = NetworkGetNetworkIdFromEntity(veh)
    local rentedcar = {}
    rentedcar.veh = veh
    rentedcar.netid = netId
    rentedcar.owner = src
    rentedcar.model = model
    rentedcar.returnprice = returnprice
    rentedcar.carspawn = carspawn
    rentedcar.rentid = rentid
    rentedcar.carspot = carspot

    if RentedCars[src] == nil then
        RentedCars[src] = {}
    end

    TriggerClientEvent("vehiclekeys:client:SetOwner", src, GetVehicleNumberPlateText(veh))

    -- insert sql
    MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state, rent) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)', {
        pData.PlayerData.license,
        cid,
        rentedcar.model,
        GetHashKey(veh),
        '{}',
        GetVehicleNumberPlateText(veh),
        'pillboxgarage',
        0,
        expireTime
    })

    RentedCars[src][carspot] = rentedcar

    TriggerClientEvent('dg-rental:client:setupvehicle', src, netId)
    Wait(100)
    StartSpotLoop()
end

function GetDistanceBetweenCoords(coord1_in, coord2_in)
    local x1 = coord1_in.x
    local x2 = coord2_in.x
    local y1 = coord1_in.y
    local y2 = coord2_in.y
    local z1 = coord1_in.z
    local z2 = coord2_in.z
    local distance = math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
    return distance
end


function StartSpotLoop()
    if InSpotLoop == false then
        InSpotLoop = true
        SpotLoop()
    end
end

function SpotLoop()
    while InSpotLoop == true do
        Wait(500)
        local dospotsloop = false
        for k,v in pairs(RentedCars) do
            Wait(100)
            for k,v in pairs(v) do
                if VehicleSpots[v.rentid][v.carspot].used == true then
                    Wait(10)
                    dospotsloop = true
                    dospotsloop = true
                    local spotcord = v.carspawn
                    local vehcord = GetEntityCoords(v.veh)
                    if GetDistanceBetweenCoords(spotcord, vehcord) >= 20 then
                        VehicleSpots[v.rentid][v.carspot].used = false
                        table.remove(RentedCars[v.owner], k)
                    end
                end
            end
        end
        Wait(100)
        if dospotsloop == false then
            InSpotLoop = false
            Wait(1)
            return 1
        end
        Wait(500)
    end
end