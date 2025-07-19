extends PopupPanel

var shelf: Node = null

func _ready():
	var items = ["Cereal", "Apples"]
	for name in items:
		var btn = Button.new()
		btn.text = name
		btn.pressed.connect(_on_item_selected.bind(name))
		$VBoxContainer.add_child(btn)
		
	for button in $VBoxContainer.get_children():
		button.pressed.connect(_on_item_selected.bind(button.text))

func _on_item_selected(item_id: String):
	if shelf:
		shelf.populate_with_item(item_id)
	queue_free()
