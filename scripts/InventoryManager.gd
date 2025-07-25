extends Node

# inventory is what the store current has in stock
# keys are the ID of the Item
# values are objects that store the current unit stock and sale price
# {
#     "apple": { "stock": 10, "sale_price": 2.00 },
#     "milk": { "stock": 200, "sale_price": 4.95 }
# }
var inventory: Dictionary = {}

# purchase_stock attempts to purchase qty units of item. Returns true if successful
func purchase_stock(item_id: String, qty: int) -> bool:
	var item: Item = ItemDatabase.get_item(item_id)
	var purchase_price = qty * item.uint_price
	if purchase_price > StoreManager.bank:
		print("not enough money") # TODO need a notifications area
		return false
	
	StoreManager.bank -= purchase_price
	if inventory.has(item_id):
		inventory[item_id]["stock"] += qty
	else:
		inventory[item_id] = {
			"stock": qty,
			"sale_price": item.sale_price
		}
	return true
