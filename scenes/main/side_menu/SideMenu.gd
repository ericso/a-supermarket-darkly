extends Panel

# SideMenu handling
@onready var side_menu := self
@onready var tab_button := $TabButton
@onready var margin_container := $MarginContainer

@export var menu_width: int = 220
@export var menu_height: int = 720

var side_menu_visible: bool = false

# Children Panel handling
@export var fade_duration := 0.3

var current_panel: Control = null
var panel_stack: Array[Control] = []
var tween: Tween = null

func _ready() -> void:
	set_up_side_menu()
	tab_button.pressed.connect(on_tab_button_pressed)
	
	current_panel = $MarginContainer/VBoxContainer/MainPanel
	current_panel.visible = true
	current_panel.modulate.a = 1.0
	
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

### ----------------------------------------------------------------------------
func show_panel(new_panel: Control):
	if current_panel == new_panel:
		return
	
	panel_stack.append(current_panel)
	transition_to_panel(new_panel, -1)

func go_back():
	if panel_stack.is_empty():
		return
	
	var previous = panel_stack.pop_back()
	transition_to_panel(previous, 1)

func transition_to_panel(new_panel: Control, direction: int):
	var old_panel = current_panel
	current_panel = new_panel

	# Fade out old panel
	var t = create_tween_for_panel()
	t.tween_property(old_panel, "modulate:a", 0.0, fade_duration)

	# Fade in new panel
	new_panel.visible = true
	new_panel.modulate.a = 0.0
	t.parallel().tween_property(new_panel, "modulate:a", 1.0, fade_duration)

	t.finished.connect(func ():
		if is_instance_valid(old_panel):
			old_panel.visible = false
	)

func create_tween_for_panel() -> Tween:
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	return tween
