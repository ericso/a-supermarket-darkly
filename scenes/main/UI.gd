extends CanvasLayer

@onready var money_label := $MarginContainer/PanelContainer/Money

@onready var menu_button := $ButtonContainer/HBoxContainer/MenuButton
@onready var shelf_button := $ButtonContainer/HBoxContainer/ShelfButton

signal place_shelf_button_pressed

func _ready() -> void:
	$MenuPanel.hide()
	menu_button.pressed.connect(on_menu_button_pressed)
	shelf_button.pressed.connect(on_shelf_button_pressed)

func _process(_delta) -> void:
	update_money_label()

func update_money_label():
	money_label.text = "Money: $%0.2f" % FinanceManager.reserves

func on_menu_button_pressed():
	var menu = $MenuPanel
	menu.refresh_tabs()
	menu.popup_centered()

func on_shelf_button_pressed():
	emit_signal("place_shelf_button_pressed")

func set_place_shelf_mode_enabled(enabled: bool):
	shelf_button.text = "Placing Shelves" if enabled else "Place Shelves"
	shelf_button.modulate = Color(0.7, 1, 0.7) if enabled else Color(1, 1, 1)
