extends PopupPanel

@onready var item_list = $VBoxContainer/ItemList

func _ready():
	$VBoxContainer/CloseButton.pressed.connect(on_close_pressed)
	populate_items()
	

func populate_items():
	item_list.clear()
	for item_id in ItemDatabase.get_item_ids():
		var stock = InventoryManager.get_stock(item_id)
		item_list.add_item("%s: %d" % [item_id.capitalize(), stock])

func on_buy_pressed(item_name: String):
	StoreManager.purchase_stock(item_name, 10)
	populate_items()

func on_close_pressed():
	hide()
