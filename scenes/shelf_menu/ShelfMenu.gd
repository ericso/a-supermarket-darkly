extends PopupPanel

var shelf: Node = null

func _ready():
	for item in ItemDatabase.get_item_ids():
		var btn = Button.new()
		btn.text = item
		btn.pressed.connect(_on_item_selected.bind(item))
		$VBoxContainer.add_child(btn)

func _on_item_selected(id: String):
	if shelf:
		shelf.stock_with_item(id)
		shelf.restock()
	queue_free()
