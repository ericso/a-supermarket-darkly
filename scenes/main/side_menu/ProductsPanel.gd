extends VBoxContainer

signal back_button_pressed

@export var side_menu_path: NodePath

func on_back_button_pressed():
	emit_signal("back_button_pressed")
	var side_menu = get_node(side_menu_path)
	side_menu.go_back()
