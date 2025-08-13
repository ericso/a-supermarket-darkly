extends VBoxContainer

@onready var money_label := $MoneyLabel

@export var side_menu_path: NodePath
@export var store_panel_path: NodePath

func _process(_delta) -> void:
	update_money_label()

func update_money_label():
	money_label.text = "Money: $%0.2f" % FinanceManager.reserves

func on_store_button_pressed():
	var side_menu = get_node(side_menu_path)
	var store_panel = get_node(store_panel_path)
	side_menu.show_panel(store_panel)
