extends MarginContainer

@onready var product_list = $BoxContainer/ProductList

# TODO purchase_amount should be set in UI
var purchase_amount: int = 100

func _ready():
	populate_items()
	product_list.item_selected.connect(on_buy_pressed)

func populate_items():
	# TODO remove after debugging
	NotificationManager.add_log_message("populate_items")
	product_list.clear()
	for product_id in ProductDatabase.get_product_ids():
		var stock = InventoryManager.get_stock(product_id)
		var index = product_list.add_item("%s: %d" % [product_id.capitalize(), stock])
		
		product_list.set_item_metadata(index, product_id)

func on_buy_pressed(index: int):
	var product_id = product_list.get_item_metadata(index)
	InventoryManager.purchase_stock(product_id, purchase_amount)
	populate_items()
	NotificationManager.add_toast("bought %d of %s" % [purchase_amount, product_id])

func on_close_pressed():
	hide()
