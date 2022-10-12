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
