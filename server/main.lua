local QBCore = exports['qb-core']:GetCoreObject()

local Code = math.random(1, 100)
local goted = {}

RegisterNetEvent('durability:Req', function()
    local src = source
    if not goted[src] then
        goted[src] = true
        TriggerClientEvent('durability:Res', src, Code)
    else
        DropPlayer(src, "Try To Bypass EasyPixel")
    end
end)

RegisterNetEvent('durability:server:update', function(EP, items)
    local src = source
    if EP == Code then
        Player = QBCore.Functions.GetPlayer(src)
        Player.Functions.SetInventory(items, true)
    else
        print("Id: "..src.." Try to add Item with "..GetCurrentResourceName())
    end
end)

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(Config.updateStashs * 1000 * 60 * 60)
        local data = MySQL.query.await('SELECT * FROM stashitems', {})
        if data[1] then
            for i=1, #data, 1 do
                if data[i] then
                    local inventory = json.decode(data[i].items)
                    if next(inventory) then
                        for _, item in pairs(inventory) do
                            if item.name then
                                if Config.items[item.name] then
                                    if item.info == '' then
                                        item.info = {}
                                    end
                                    if item.info.quality == nil then
                                        item.info.quality = 100
                                    end
                                    item.info.quality = item.info.quality - Config.items[item.name]
                                    if item.info.quality < 0 then
                                        item.info.quality = 0
                                    end
                                    inventory[_] = item
                                end
                            end
                        end
                    end
                    MySQL.prepare('UPDATE stashitems SET items = ? WHERE stash = ?', { json.encode(inventory), data[i].stash })
                end
            end
        end
    end
end)

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(Config.updateTrunks * 1000 * 60 * 60)
        local data = MySQL.query.await('SELECT * FROM trunkitems', {})
        if data[1] then
            for i=1, #data, 1 do
                if data[i] then
                    local inventory = json.decode(data[i].items)
                    if next(inventory) then
                        for _, item in pairs(inventory) do
                            if item.name then
                                if Config.items[item.name] then
                                    if item.info == '' then
                                        item.info = {}
                                    end
                                    if item.info.quality == nil then
                                        item.info.quality = 100
                                    end
                                    item.info.quality = item.info.quality - Config.items[item.name]
                                    if item.info.quality < 0 then
                                        item.info.quality = 0
                                    end
                                    inventory[_] = item
                                end
                            end
                        end
                    end
                    MySQL.prepare('UPDATE trunkitems SET items = ? WHERE plate = ?', { json.encode(inventory), data[i].plate })
                end
            end
        end
    end
end)

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(Config.updateGlovBoxs * 1000 * 60 * 60)
        local data = MySQL.query.await('SELECT * FROM gloveboxitems', {})
        if data[1] then
            for i=1, #data, 1 do
                if data[i] then
                    local inventory = json.decode(data[i].items)
                    if next(inventory) then
                        for _, item in pairs(inventory) do
                            if item.name then
                                if Config.items[item.name] then
                                    if item.info == '' then
                                        item.info = {}
                                    end
                                    if item.info.quality == nil then
                                        item.info.quality = 100
                                    end
                                    item.info.quality = item.info.quality - Config.items[item.name]
                                    if item.info.quality < 0 then
                                        item.info.quality = 0
                                    end
                                    inventory[_] = item
                                end
                            end
                        end
                    end
                    MySQL.prepare('UPDATE gloveboxitems SET items = ? WHERE plate = ?', { json.encode(inventory), data[i].plate })
                end
            end
        end
    end
end)