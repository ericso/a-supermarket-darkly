extends PopupPanel

@onready var item_list = $VBoxContainer/ItemList

# TODO purchase_amount should be set in UI
var purchase_amount: int = 100

func _ready():
	$VBoxContainer/CloseButton.pressed.connect(on_close_pressed)
	populate_items()
	item_list.item_selected.connect(on_buy_pressed)

func populate_items():
	item_list.clear()
	for item_id in ItemDatabase.get_item_ids():
		var stock = InventoryManager.get_stock(item_id)
		var index = item_list.add_item("%s: %d" % [item_id.capitalize(), stock])
		item_list.set_item_metadata(index, item_id)

func on_buy_pressed(index: int):
	var item_id = item_list.get_item_metadata(index)
	InventoryManager.purchase_stock(item_id, purchase_amount)
	populate_items()

func on_close_pressed():
	hide()
