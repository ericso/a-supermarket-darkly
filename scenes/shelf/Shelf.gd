extends Node2D

@export var item_id: int = -1
@export var quantity: int = 0

@onready var tap_hold_timer: Timer = $TapHoldTimer
var is_mouse_over = false

@onready var item_sprite := $ItemSprite

func _ready():
	tap_hold_timer.wait_time = 0.5
	tap_hold_timer.one_shot = true
	tap_hold_timer.timeout.connect(_on_hold)

	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)

func _on_hold():
	if is_mouse_over:
		open_shelf_menu()

func _input(event):
	if is_mouse_over:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				tap_hold_timer.start()
			else:
				tap_hold_timer.stop()

func _on_mouse_entered():
	is_mouse_over = true

func _on_mouse_exited():
	is_mouse_over = false
	tap_hold_timer.stop()

func open_shelf_menu():
	var menu = preload("res://scenes/shelf_menu/ShelfMenu.tscn").instantiate()
	get_tree().current_scene.add_child(menu)
	menu.popup()
	menu.position = get_viewport().get_mouse_position()
	menu.shelf = self

func populate_with_item(id: String):
	print("DEBUG::populate_with_item ID ", id)
	item_sprite.texture = load_item_texture(id)

func load_item_texture(id: String) -> Texture2D:
	match id:
		"Apple":
			return preload("res://assets/apple.png")
		"Cereal":
			return preload("res://assets/cereal.png")
		_:
			return null
