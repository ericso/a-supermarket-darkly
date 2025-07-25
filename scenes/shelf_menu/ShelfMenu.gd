extends PopupPanel

var shelf: Node = null

func _ready():
	populate_menu(InventoryManager.get_inventory_ids())

func populate_menu(item_ids: Array):
	var default_label = $VBoxContainer/NoItemsLabel
	default_label.visible = item_ids.is_empty()
	
	for child in $VBoxContainer.get_children():
		if child != default_label:
			child.queue_free()
	
	for id in item_ids:
		var btn = Button.new()
		btn.text = id.capitalize()
		btn.pressed.connect(on_item_selected.bind(id))
		$VBoxContainer.add_child(btn)

func on_item_selected(id: String):
	if shelf:
		shelf.stock_with_item(id)
		shelf.restock()
	queue_free()
