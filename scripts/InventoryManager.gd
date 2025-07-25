extends Node

# inventory is what the store currently has in stock
# keys are the ID of the Item
# values are objects that store the current unit stock and sale price
# {
#     "apple": { "stock": 10, "sale_price": 2.00 },
#     "milk": { "stock": 200, "sale_price": 4.95 }
# }
var inventory: Dictionary = {}

# items_sold keys are Item objects, value is the amount of that item sold
var items_sold: Dictionary = {}

# purchase_stock attempts to purchase qty units of item. Returns true if successful
func purchase_stock(item_id: String, qty: int) -> bool:
	var item: Item = ItemDatabase.get_item(item_id)
	var purchase_price = qty * item.unit_price
	if purchase_price > FinanceManager.bank:
		print("not enough money") # TODO need a notifications area
		return false
	
	FinanceManager.bank -= purchase_price
	if inventory.has(item_id):
		inventory[item_id].stock += qty
	else:
		inventory[item_id] = {
			"stock": qty,
			"sale_price": item.sale_price
		}
	return true

# get_stock returns the amount of item that is in stock
func get_stock(item_id: String) -> int:
	if !inventory.has(item_id):
		return 0
	return inventory[item_id].stock

# get_stock_ids returns the keys in inventory Dictionary, regardless of
# whether or not there is current stock
func get_inventory_ids() -> Array:
	return inventory.keys()

# move_stock_to_shelf tries to subtract qty of item from inventory and returns
# the amount it was actually able to subtract.
func move_stock_to_shelf(item_id: String, qty: int) -> int:
	var in_stock_qty = inventory[item_id].stock
	if in_stock_qty < qty:
		inventory[item_id].stock = 0
		return in_stock_qty
	inventory[item_id].stock -= qty
	return qty

func record_item_sold(item: Item, qty: int):
	if !items_sold.has(item):
		items_sold[item] = qty
	else:
		items_sold[item] += qty
