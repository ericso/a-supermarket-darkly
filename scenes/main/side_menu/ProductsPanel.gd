extends VBoxContainer

signal back_button_pressed

@export var side_menu_path: NodePath
@export var product_list_path: NodePath

# TODO purchase_amount should be set in UI
var purchase_amount: int = 100

func _ready():
	var product_list = get_node(product_list_path)
	product_list.item_selected.connect(on_buy_pressed)
	# TODO play with sizing (maybe set it dynamically)
	product_list.custom_minimum_size = Vector2(100, 200)

func populate_items():
	var product_list = get_node(product_list_path)
	product_list.clear()
	for product_id in ProductDatabase.get_product_ids():
		var stock = InventoryManager.get_stock(product_id)
		var index = product_list.add_item("%s: %d" % [product_id.capitalize(), stock])
		product_list.set_item_metadata(index, product_id)

func on_buy_pressed(index: int):
	var product_list = get_node(product_list_path)
	var product_id = product_list.get_item_metadata(index)
	var success: bool = InventoryManager.purchase_stock(product_id, purchase_amount)
	if success:
		populate_items()
		NotificationManager.add_toast("bought %d of %s" % [purchase_amount, product_id])

func on_back_button_pressed():
	emit_signal("back_button_pressed")
	var side_menu = get_node(side_menu_path)
	side_menu.go_back()
