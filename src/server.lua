local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-durability:server:Decay', function(itemName, damage, Slot)
    local src = source
    DecayItem(src, itemName, damage, Slot)
end)

Citizen.CreateThread(function()
    while true do
        -- Citizen.Wait(Config.updateOnlinePlayers * 1000 * 60 * 60)
        Citizen.Wait(10000)
        local players = QBCore.Functions.GetQBPlayers()
        for src, Player in pairs(players) do
            if Player then
                local inventory = Player.PlayerData.items
                for _, item in pairs(inventory) do
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
                        inventory[item.slot] = item
                    end
                end
                Player.Functions.SetInventory(inventory, true)
            end
        end
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

function DecayItem(src, itemName, damage, Slot)
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        local inventory = Player.PlayerData.items
        local slot = Slot or QBCore.Player.GetFirstSlotByItem(inventory, itemName)
        if slot ~= nil then
            local usedItem = inventory[slot]
            if usedItem.info == '' then
                usedItem.info = {}
            end
            if usedItem.info.quality == nil then
                usedItem.info.quality = 100
            end
            usedItem.info.quality = usedItem.info.quality - damage
            if usedItem.info.quality < 0 then
                usedItem.info.quality = 0
            end
            inventory[slot] = usedItem
            Player.Functions.SetInventory(inventory, true)
            return true
        end
    end
    return false
end

exports('DecayItem', DecayItem)