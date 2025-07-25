extends MarginContainer

@onready var product_list = $BoxContainer/ProductList

# TODO purchase_amount should be set in UI
var purchase_amount: int = 100

func _ready():
	populate_items()
	product_list.item_selected.connect(on_buy_pressed)

func populate_items():
	print("DEBUG::populate_items")
	product_list.clear()
	for product_id in ProductDatabase.get_product_ids():
		var stock = InventoryManager.get_stock(product_id)
		print("DEBUG::populate_items product_id ", product_id, stock)
		var index = product_list.add_item("%s: %d" % [product_id.capitalize(), stock])
		
		product_list.set_item_metadata(index, product_id)
	print("DEBUG: product_list node = ", product_list)

func on_buy_pressed(index: int):
	var product_id = product_list.get_item_metadata(index)
	InventoryManager.purchase_stock(product_id, purchase_amount)
	populate_items()

func on_close_pressed():
	hide()
