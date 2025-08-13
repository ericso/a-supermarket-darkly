extends CanvasLayer

# TODO move the menu panel stuff into a script attached to the MenuPanel node
@onready var menu_button := $ButtonContainer/HBoxContainer/MenuButton
@onready var menu_panel := $MenuPanel

func _ready() -> void:
	menu_panel.hide()
	menu_button.pressed.connect(on_menu_button_pressed)

func on_menu_button_pressed():
	menu_panel.refresh_tabs()
	menu_panel.popup_centered()
