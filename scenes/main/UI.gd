extends CanvasLayer

@onready var margin_container := $SideMenu/MarginContainer

@onready var money_label := $SideMenu/MarginContainer/VBoxContainer/MoneyLabel
@onready var shelf_button := $SideMenu/MarginContainer/VBoxContainer/ShelfButton
@onready var checkout_button := $SideMenu/MarginContainer/VBoxContainer/CheckoutButton

@onready var menu_button := $ButtonContainer/HBoxContainer/MenuButton

@onready var menu_panel := $MenuPanel
@onready var side_menu := $SideMenu
@onready var side_menu_tab_button := $TabButton

@export var menu_width: int = 220
@export var menu_height: int = 720
@export var button_width: int = 40
@export var button_height: int = 40

var side_menu_visible: bool = false

signal place_shelf_button_pressed
signal place_checkout_button_pressed

func _ready() -> void:
	menu_panel.hide()
	menu_button.pressed.connect(on_menu_button_pressed)
	shelf_button.pressed.connect(on_shelf_button_pressed)
	checkout_button.pressed.connect(on_checkout_button_pressed)
	
	set_up_side_menu()
	side_menu_tab_button.pressed.connect(on_side_menu_tab_button_pressed)

func set_up_side_menu() -> void:
	side_menu.anchor_right = 1.0
	side_menu.anchor_left = 1.0
	side_menu.anchor_top = 0.0
	side_menu.anchor_bottom = 0.0
	side_menu.size = Vector2i(menu_width, menu_height)
	side_menu.position = Vector2i(-menu_width, 0)
	
	side_menu_tab_button.anchor_left = 0.0
	side_menu_tab_button.anchor_top = 0.5
	side_menu_tab_button.anchor_bottom = 0.5
	side_menu_tab_button.position = Vector2(0, 20)
	side_menu_tab_button.size = Vector2i(button_width, button_height)

func on_side_menu_tab_button_pressed() -> void:
	side_menu_visible = !side_menu_visible
	animate_menu_slide(side_menu_visible)
	update_menu_tab_button(side_menu_visible)

func animate_menu_slide(show_menu: bool):
	var menu_target_x = 0 if show_menu else -menu_width
	var button_target_x = menu_width if show_menu else 0
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(side_menu, "position:x", menu_target_x, 0.3)
	tween.tween_property(side_menu_tab_button, "position:x", button_target_x, 0.3)
 
func update_menu_tab_button(show_menu: bool) -> void:
	side_menu_tab_button.text = "<" if show_menu else ">"

func _process(_delta) -> void:
	update_money_label()
	
	if side_menu_visible:
		# resize the side menu to match its contents
		side_menu.size.x = margin_container.size.x
		
		# reposition the tab button
		# NOTE: this causes the tween animation to fail
		side_menu_tab_button.position.x = margin_container.size.x

func update_money_label():
	money_label.text = "Money: $%0.2f" % FinanceManager.reserves

func on_menu_button_pressed():
	menu_panel.refresh_tabs()
	menu_panel.popup_centered()

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
