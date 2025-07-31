extends CanvasLayer

@onready var money_label := $MarginContainer/PanelContainer/Money

func _ready() -> void:
	$MenuPanel.hide()
	$ButtonContainer/HBoxContainer/MenuButton.pressed.connect(on_menu_button_pressed)

func _process(_delta) -> void:
	update_money_label()

func update_money_label():
	money_label.text = "Money: $%0.2f" % FinanceManager.reserves

func on_menu_button_pressed():
	var menu = $MenuPanel
	menu.refresh_tabs()
	menu.popup_centered()
