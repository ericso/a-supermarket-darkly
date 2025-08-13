extends VBoxContainer

signal place_shelf_button_pressed
signal place_checkout_button_pressed

@onready var shelf_button := $ShelfButton
@onready var checkout_button := $CheckoutButton

@export var side_menu_path: NodePath

func _ready() -> void:
	shelf_button.pressed.connect(on_shelf_button_pressed)
	checkout_button.pressed.connect(on_checkout_button_pressed)

func on_shelf_button_pressed():
	emit_signal("place_shelf_button_pressed")

func on_checkout_button_pressed():
	emit_signal("place_checkout_button_pressed")

# TODO refactor placing shelves and checkouts into common code
# probably do it when changing this to purchasing checkouts and shelves
func set_place_shelf_mode_enabled(enabled: bool):
	shelf_button.text = "Placing Shelves" if enabled else "Place Shelves"
	shelf_button.modulate = Color(0.7, 1, 0.7) if enabled else Color(1, 1, 1)
	if enabled:
		Input.set_default_cursor_shape(Input.CURSOR_CROSS)
	else:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func set_place_checkout_mode_enabled(enabled: bool):
	checkout_button.text = "Placing Checkouts" if enabled else "Place Checkouts"
	checkout_button.modulate = Color(0.7, 1, 0.7) if enabled else Color(1, 1, 1)
	if enabled:
		Input.set_default_cursor_shape(Input.CURSOR_CROSS)
	else:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func on_back_button_pressed():
	var side_menu = get_node(side_menu_path)
	side_menu.go_back()
