![decay](https://user-images.githubusercontent.com/81551013/195077592-01b1fb1e-dd12-4af8-b9fc-c8a0ed971d72.png)

### qb-durability
Items Decay System For QBCore Framework. Include Players Inventory, Trunks, Gloveboxs and Stashes.

### Dependencies
* [QBCore](https://github.com/qbcore-framework/qb-core)
* [Ox MySQL](https://github.com/overextended/oxmysql)
* [LJ Inevntory](https://github.com/loljoshie/lj-inventory)

### Inventory
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

### Server Export
* You can use DecayItem export in server side.

```lua
exports['qb-durability']:DecayItem(source, itemName, DamageAmount, Slot) -- Slot is optional
```

### Server Event
* You can use Decay server event in client side.

```lua
TriggerServerEvent("durability:server:Decay", itemName, DamageAmount, Slot) -- Slot is optional
```

### Credits
* [TNJ](https://github.com/orgs/tnj-development)

<br>

##### Copyright © 2022 theMani_kh. All rights reserved.
