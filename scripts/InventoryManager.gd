extends Node

# inventory is what the store currently has in stock
# keys are the ID of the Product
# values are objects that store the current unit stock and sale price
# {
#     "apple": { "stock": 10, "sale_price": 2.00 },
#     "milk": { "stock": 200, "sale_price": 4.95 }
# }
var inventory: Dictionary[String, Dictionary] = {}

# products_sold_count keys are Product ids, value is the quantity of that product sold
var products_sold_count: Dictionary = {}

# populate_inventory initializes the inventory Dictionary with purchasable products
func populate_inventory() -> void:
	for product_id in ProductDatabase.get_product_ids():
		inventory[product_id] = { "stock": 0, "sale_price": 0 }

# purchase_stock attempts to purchase qty units of product. Returns true if successful
func purchase_stock(product_id: String, qty: int) -> bool:
	var product: Product = ProductDatabase.get_product(product_id)
	var purchase_price = qty * product.unit_price
	if purchase_price > FinanceManager.reserves:
		NotificationManager.add_toast("not enough money")
		return false
	
	FinanceManager.reserves -= purchase_price
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

func sell_product(product_id: String, qty: int):
	if !products_sold_count.has(product_id):
		products_sold_count[product_id] = qty
	else:
		products_sold_count[product_id] += qty
	FinanceManager.record_sale(product_id, qty)

func get_sold_count(product_id: String) -> int:
	if !products_sold_count.has(product_id):
		return 0
	else:
		return products_sold_count[product_id]
	
