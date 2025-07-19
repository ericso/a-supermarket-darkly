extends PopupPanel

var shelf: Node = null

func _ready():
	for item in ItemDatabase.get_item_ids():
		var btn = Button.new()
		btn.text = item
		btn.pressed.connect(_on_item_selected.bind(item))
		$VBoxContainer.add_child(btn)
		
	for button in $VBoxContainer.get_children():
		button.pressed.connect(_on_item_selected.bind(button.text))

func _on_item_selected(id: String):
	if shelf:
		shelf.populate_with_item(id, 10)
	queue_free()
