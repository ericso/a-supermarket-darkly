extends Panel

@onready var side_menu := self
@onready var tab_button := $TabButton
@onready var margin_container := $MarginContainer

@export var menu_width: int = 220
@export var menu_height: int = 720

var side_menu_visible: bool = false

func _ready() -> void:
	set_up_side_menu()
	tab_button.pressed.connect(on_tab_button_pressed)

func _process(_delta) -> void:
	if side_menu_visible:
		# resize the side menu to match its contents
		side_menu.size.x = margin_container.size.x
		
		# reposition the tab button
		tab_button.position.x = margin_container.size.x

func set_up_side_menu() -> void:
	side_menu.anchor_right = 1.0
	side_menu.anchor_left = 1.0
	side_menu.anchor_top = 0.0
	side_menu.anchor_bottom = 0.0
	side_menu.size = Vector2i(menu_width, menu_height)
	side_menu.position = Vector2i(-menu_width, 0)
	
	tab_button.anchor_left = 0.0
	tab_button.anchor_top = 0.5
	tab_button.anchor_bottom = 0.5
	# put the tab button at the right edge of the side menu
	tab_button.position = Vector2(menu_width, 20)

func on_tab_button_pressed() -> void:
	side_menu_visible = !side_menu_visible
	animate_menu_slide(side_menu_visible)
	update_menu_tab_button(side_menu_visible)

func animate_menu_slide(show_menu: bool):
	var menu_target_x = 0 if show_menu else -menu_width
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(side_menu, "position:x", menu_target_x, 0.3)
 
func update_menu_tab_button(show_menu: bool) -> void:
	tab_button.text = "<" if show_menu else ">"
