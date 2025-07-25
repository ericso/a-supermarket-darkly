extends PopupPanel

func _ready():
	$VBoxContainer/Header/CloseButton.pressed.connect(on_close_pressed)
	refresh_tabs()

func refresh_tabs():
	$VBoxContainer/Content/Tabs/ProductTab.populate_items()

func on_close_pressed():
	hide()
