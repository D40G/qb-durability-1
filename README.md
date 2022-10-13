![decay](https://user-images.githubusercontent.com/81551013/195077592-01b1fb1e-dd12-4af8-b9fc-c8a0ed971d72.png)

### qb-durability
Items Decay System For QBCore Framework. Include Players Inventory, Trunks, Gloveboxs and Stashes.

### Dependencies
* [QBCore](https://github.com/qbcore-framework/qb-core)
* [Ox MySQL](https://github.com/overextended/oxmysql)
* [LJ Inevntory](https://github.com/loljoshie/lj-inventory)

### Quality Info
* For Show Bar and Item Quality in Inventory, Download tnj-inventory and replace html,css,js files with your Inventory Ui.

* [TNJ Inventory](https://github.com/tnj-development/inventory)

* Also you have to replace bellow code with events handler in lj-inventory\server\main.lua lines 1342 to 1369

```lua
RegisterNetEvent('inventory:server:UseItemSlot', function(slot)
	local src = source
	local itemData = GetItemBySlot(src, slot)
	if not itemData then return end
	local itemInfo = QBCore.Shared.Items[itemData.name]
	if itemData.type == "weapon" then
		TriggerClientEvent("inventory:client:UseWeapon", src, itemData, itemData.info.quality and itemData.info.quality > 0)
		TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "use")
	elseif itemData.useable then
		if itemData.info.quality then
			if itemData.info.quality > 0 then
				UseItem(itemData.name, src, itemData)
				TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "use")
			else
				TriggerClientEvent("QBCore:Notify", src, "You can't use this item", "error")
			end
		else
			UseItem(itemData.name, src, itemData)
			TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "use")
		end
	end
end)

RegisterNetEvent('inventory:server:UseItem', function(inventory, item)
	local src = source
	if inventory ~= "player" and inventory ~= "hotbar" then return end
	local itemData = GetItemBySlot(src, item.slot)
	if not itemData then return end
	local itemInfo = QBCore.Shared.Items[itemData.name]
	if itemData.type == "weapon" then
		TriggerClientEvent("inventory:client:UseWeapon", src, itemData, itemData.info.quality and itemData.info.quality > 0)
		TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "use")
	else
		if itemData.info.quality then
			if itemData.info.quality > 0 then
				UseItem(itemData.name, src, itemData)
				TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "use")
			else
				TriggerClientEvent("QBCore:Notify", src, "You can't use this item", "error")
			end
		else
			UseItem(itemData.name, src, itemData)
			TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "use")
		end
	end
end)
```

https://user-images.githubusercontent.com/81551013/195428697-307ee516-0834-476a-b49f-48a7c5ec2b63.mp4

### Stack Items
* For fix stack items after add to inventory, with diffrent quality replace bellow code with AddItem Function in lj-inventory\server\main.lua lines 139-196

```lua
local function AddItem(source, item, amount, slot, info)
	local Player = QBCore.Functions.GetPlayer(source)

	if not Player then return false end

	local totalWeight = GetTotalWeight(Player.PlayerData.items)
	local itemInfo = QBCore.Shared.Items[item:lower()]
	if not itemInfo and not Player.Offline then
		QBCore.Functions.Notify(source, "Item does not exist", 'error')
		return false
	end

	amount = tonumber(amount) or 1
	slot = tonumber(slot) or GetFirstSlotByItem(Player.PlayerData.items, item)
	info = info or {}

	if itemInfo['type'] == 'weapon' then
		info.serie = info.serie or tostring(QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(4))
		info.quality = info.quality or 100
	end
	if (totalWeight + (itemInfo['weight'] * amount)) <= Config.MaxInventoryWeight then
		if (slot and Player.PlayerData.items[slot]) and (Player.PlayerData.items[slot].name:lower() == item:lower()) and (itemInfo['type'] == 'item' and not itemInfo['unique']) and ((not info.quality and (not Player.PlayerData.items[slot].info.quality or Player.PlayerData.items[slot].info.quality == '' or Player.PlayerData.items[slot].info.quality == 100)) or (info.quality and (info.quality == Player.PlayerData.items[slot].info.quality))) then
			Player.PlayerData.items[slot].amount = Player.PlayerData.items[slot].amount + amount
			Player.Functions.SetPlayerData("items", Player.PlayerData.items)

			if Player.Offline then return true end

			TriggerEvent('qb-log:server:CreateLog', 'playerinventory', 'AddItem', 'green', '**' .. GetPlayerName(source) .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')** got item: [slot:' .. slot .. '], itemname: ' .. Player.PlayerData.items[slot].name .. ', added amount: ' .. amount .. ', new total amount: ' .. Player.PlayerData.items[slot].amount)

			return true
		elseif slot and Player.PlayerData.items[slot] == nil then
			Player.PlayerData.items[slot] = { name = itemInfo['name'], amount = amount, info = info or '', label = itemInfo['label'], description = itemInfo['description'] or '', weight = itemInfo['weight'], type = itemInfo['type'], unique = itemInfo['unique'], useable = itemInfo['useable'], image = itemInfo['image'], shouldClose = itemInfo['shouldClose'], slot = slot, combinable = itemInfo['combinable'] }
			Player.Functions.SetPlayerData("items", Player.PlayerData.items)

			if Player.Offline then return true end

			TriggerEvent('qb-log:server:CreateLog', 'playerinventory', 'AddItem', 'green', '**' .. GetPlayerName(source) .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')** got item: [slot:' .. slot .. '], itemname: ' .. Player.PlayerData.items[slot].name .. ', added amount: ' .. amount .. ', new total amount: ' .. Player.PlayerData.items[slot].amount)

			return true
		else
			for i = 1, Config.MaxInventorySlots, 1 do
				if Player.PlayerData.items[i] == nil then
					Player.PlayerData.items[i] = { name = itemInfo['name'], amount = amount, info = info or '', label = itemInfo['label'], description = itemInfo['description'] or '', weight = itemInfo['weight'], type = itemInfo['type'], unique = itemInfo['unique'], useable = itemInfo['useable'], image = itemInfo['image'], shouldClose = itemInfo['shouldClose'], slot = i, combinable = itemInfo['combinable'] }
					Player.Functions.SetPlayerData("items", Player.PlayerData.items)

					if Player.Offline then return true end

					TriggerEvent('qb-log:server:CreateLog', 'playerinventory', 'AddItem', 'green', '**' .. GetPlayerName(source) .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')** got item: [slot:' .. i .. '], itemname: ' .. Player.PlayerData.items[i].name .. ', added amount: ' .. amount .. ', new total amount: ' .. Player.PlayerData.items[i].amount)

					return true
				end
			end
		end
	elseif not Player.Offline then
		QBCore.Functions.Notify(source, "Inventory too full", 'error')
	end
	return false
end
```

### Server Export
* You can use DecayItem export in server side.

```lua
exports['qb-durability']:DecayItem(source, itemName, DamageAmount, Slot) -- Slot is optional
```

### Server Event
* You can use Decay server event in client side.

```lua
TriggerServerEvent("qb-durability:server:Decay", itemName, DamageAmount, Slot) -- Slot is optional
```

### Credits
* [TNJ](https://github.com/orgs/tnj-development)

<br>

##### Copyright © 2022 theMani_kh. All rights reserved.
