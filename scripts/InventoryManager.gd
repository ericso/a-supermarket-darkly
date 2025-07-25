extends Node

# inventory is what the store currently has in stock
# keys are the ID of the Item
# values are objects that store the current unit stock and sale price
# {
#     "apple": { "stock": 10, "sale_price": 2.00 },
#     "milk": { "stock": 200, "sale_price": 4.95 }
# }
var inventory: Dictionary = {}

# products_sold keys are Product objects, value is the dollar amount of that
# product sold
var products_sold: Dictionary = {}

# purchase_stock attempts to purchase qty units of product. Returns true if successful
func purchase_stock(product_id: String, qty: int) -> bool:
	var product: Product = ProductDatabase.get_product(product_id)
	var purchase_price = qty * product.unit_price
	if purchase_price > FinanceManager.bank:
		print("not enough money") # TODO need a notifications area
		return false
	
	FinanceManager.bank -= purchase_price
	# store inventory
	if inventory.has(product_id):
		inventory[product_id].stock += qty
	else:
		inventory[product_id] = {
			"stock": qty,
			"sale_price": product.sale_price
		}
	# record ledger
	FinanceManager.record_purchase(product_id, qty)
	return true

# get_stock returns the amount of product that is in stock
func get_stock(product_id: String) -> int:
	if !inventory.has(product_id):
		return 0
	return inventory[product_id].stock

# get_stock_ids returns the keys in inventory Dictionary, regardless of
# whether or not there is current stock
func get_inventory_ids() -> Array:
	return inventory.keys()

# move_stock_to_shelf tries to subtract qty of product from inventory and returns
# the amount it was actually able to subtract.
func move_stock_to_shelf(product_id: String, qty: int) -> int:
	var in_stock_qty = inventory[product_id].stock
	if in_stock_qty < qty:
		inventory[product_id].stock = 0
		return in_stock_qty
	inventory[product_id].stock -= qty
	return qty

func sell_product(product: Product, qty: int):
	if !products_sold.has(product):
		products_sold[product] = qty
	else:
		products_sold[product] += qty
	FinanceManager.record_sale(product.id, qty)
