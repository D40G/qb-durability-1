![lj](https://user-images.githubusercontent.com/81551013/195077592-01b1fb1e-dd12-4af8-b9fc-c8a0ed971d72.png)

![qb](https://user-images.githubusercontent.com/81551013/195080483-ee7711df-d588-47f5-90e1-a6bf80e83b6c.png)

### qb-durability
Items Decay System For QBCore Framework. Include Players Inventory, Trunks, Gloveboxs and Stashes.

### Dependencies
* [QBCore](https://github.com/qbcore-framework/qb-core)
* [Ox MySQL](https://github.com/overextended/oxmysql)
* [QB Inevntory](https://github.com/qbcore-framework/qb-inventory) or [LJ Inevntory](https://github.com/loljoshie/lj-inventory) (my rather is LJ)

### Inventory
* According to your inventory, download the file from below. Rename file name to app.js and replace to yourInventory\html\js\app.js

* [lj-inventory](https://github.com/theMani-kh/qb-durability/files/9754830/lj.txt)

* [qb-inventory](https://github.com/theMani-kh/qb-durability/files/9754833/qb.txt)

* If you don't use Lj or Qb, You sould add quality bar or quality info in desc box for items.

* Also you have to replace bellow code with two events handler in yourInventory\server\main.lua

```lua
'inventory:server:UseItemSlot'
```
```lua
'inventory:server:UseItem'
```

* qb-inventory: lines 1453 to 1480

* lj-inventory: lines 1342 to 1369

```lua
RegisterNetEvent('inventory:server:UseItemSlot', function(slot)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local itemData = Player.Functions.GetItemBySlot(slot)
	if itemData then
		local itemInfo = QBCore.Shared.Items[itemData.name]
		if itemData.type == "weapon" then
			if itemData.info.quality then
				if itemData.info.quality > 0 then
					TriggerClientEvent("inventory:client:UseWeapon", src, itemData, true)
				else
					TriggerClientEvent("inventory:client:UseWeapon", src, itemData, false)
				end
			else
				TriggerClientEvent("inventory:client:UseWeapon", src, itemData, true)
			end
			TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "use")
		elseif itemData.useable then
			if itemData.info.quality then
				if itemData.info.quality > 0 then
					TriggerClientEvent("QBCore:Client:UseItem", src, itemData)
					TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "use")
				else
					TriggerClientEvent("QBCore:Notify", src, "You can't use this item", "error")
				end
			else
				TriggerClientEvent("QBCore:Client:UseItem", src, itemData)
				TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "use")
			end
		end
	end
end)

RegisterNetEvent('inventory:server:UseItem', function(inventory, item)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if inventory == "player" or inventory == "hotbar" then
		local itemData = Player.Functions.GetItemBySlot(item.slot)
		if itemData then
			if itemData.type ~= "weapon" then
				if itemData.info.quality then
					if itemData.info.quality <= 0 then
						TriggerClientEvent("QBCore:Notify", src, "You can't use this item", "error")
						return
					end
				end
			end
			TriggerClientEvent("QBCore:Client:UseItem", src, itemData)
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
* [TNJ](https://github.com/orgs/tnj-development) For lj-inventory's Decay UI

<br>

##### Copyright © 2022 theMani_kh. All rights reserved.
