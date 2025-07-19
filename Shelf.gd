extends Node2D

@export var item_id: int = -1
@export var quantity: int = 0

@onready var tap_hold_timer: Timer = $TapHoldTimer
var is_mouse_over = false

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
			print("DEBUG::_input is_mouse_over event ", event)
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
	var menu = preload("res://ShelfMenu.tscn").instantiate()
	get_tree().current_scene.add_child(menu)
	menu.popup()
	menu.position = get_viewport().get_mouse_position()
	menu.shelf = self

func populate_with_item(id: String):
	# TODO implement
	print("DEBUG::populate_with_item ID ", id)
