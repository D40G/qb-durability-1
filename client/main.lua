local QBCore = exports['qb-core']:GetCoreObject()

local PlayerData = {}
local LogedIn = false

local Code = nil

RegisterNetEvent("durability:Res", function(EP)
	Code = EP
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
    PlayerData = QBCore.Functions.GetPlayerData()
    LogedIn = true
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    LogedIn = false
    PlayerData = {}
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    PlayerData = val
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        LogedIn = false
        PlayerData = {}
    end
end)

Citizen.CreateThread(function()
    TriggerServerEvent("durability:Req")
    while true do
        Citizen.Wait(Config.updateOnlinePlayers * 1000 * 60 * 60)
        if LogedIn then
            local inventory = PlayerData.items
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
            TriggerServerEvent('durability:server:update', Code, inventory)
        end
    end
end)