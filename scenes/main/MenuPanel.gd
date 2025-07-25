extends PopupPanel

func _ready():
	$MarginContainer/VBoxContainer/HBoxContainer/CloseButton.pressed.connect(on_close_pressed)
	refresh_tabs()

func refresh_tabs():
	$Tabs/ProductTab.populate_items()

func on_close_pressed():
	hide()
