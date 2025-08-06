extends Node2D

@onready var ui: CanvasLayer = get_parent().get_node("UI")

@onready var shelf_scene = preload("res://scenes/shelf/Shelf.tscn")
var shadow_shelf_scene: Node2D = null

@onready var checkout_scene = preload("res://scenes/checkout/Checkout.tscn")
var shadow_checkout_scene: Node2D = null

@onready var store_map: TileMapLayer = get_parent().get_node("Store")
@onready var nav_region: NavigationRegion2D = get_parent().get_node("NavigationRegion")

# shadow_shelf_scene is used to show where a shelf will be placed
var is_placing_shelf: bool = false
var is_placing_checkout: bool = false

func _ready() -> void:
	ui.connect("place_shelf_button_pressed", self.on_place_shelf_pressed)
	ui.connect("place_checkout_button_pressed", self.on_place_checkout_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if is_placing_shelf and event is InputEventMouseButton and event.pressed:
		var tile_pos = store_map.local_to_map(event.position)
		if can_place_shelf_at(tile_pos):
			place_shelf_at(tile_pos)

func _process(_delta) -> void:
	if is_placing_shelf and shadow_shelf_scene: 
		var mouse_pos = get_global_mouse_position()
		var tile_pos: Vector2i = store_map.local_to_map(mouse_pos)
		var snapped_pos = store_map.map_to_local(tile_pos)
		shadow_shelf_scene.position = snapped_pos
		
		update_shadow_color(can_place_shelf_at(snapped_pos))

func on_place_shelf_pressed():
	ui.set_place_shelf_mode_enabled(!is_placing_shelf)
	if is_placing_shelf:
		stop_placing_shelf()
	else:
		start_placing_shelf()

func on_place_checkout_pressed():
	ui.set_place_checkout_mode_enabled(!is_placing_checkout)
	if is_placing_checkout:
		stop_placing_checkout()
	else:
		start_placing_checkout()

func can_place_shelf_at(tile_pos: Vector2i) -> bool:
	var world_pos = store_map.map_to_local(tile_pos)
	for child in get_children():
		if child is Shelf and child.position == world_pos:
			return false
	return true

func can_place_checkout_at(tile_pos: Vector2i) -> bool:
	var world_pos = store_map.map_to_local(tile_pos)
	for child in get_children():
		if child is Checkout and child.position == world_pos:
			return false
	return true

func place_shelf_at(tile_pos: Vector2i):
	var shelf = shelf_scene.instantiate()
	shelf.position = store_map.map_to_local(tile_pos)
	# shelves must be added as children of the NavigationRegion2D so that
	# customers avoid them when pathing
	nav_region.add_child(shelf)
	nav_region.bake_navigation_polygon()
	await get_tree().process_frame

func place_checkout_at(tile_pos: Vector2i):
	var checkout = checkout_scene.instantiate()
	checkout.position = store_map.map_to_local(tile_pos)
	# checkout must be added as children of the NavigationRegion2D so that
	# customers avoid them when pathing
	nav_region.add_child(checkout)
	nav_region.bake_navigation_polygon()
	await get_tree().process_frame

func start_placing_shelf() -> void:
	is_placing_shelf = true
	shadow_shelf_scene = preload("res://scenes/shelf/ShadowShelf.tscn").instantiate()
	add_child(shadow_shelf_scene)

func stop_placing_shelf() -> void:
	is_placing_shelf = false
	if shadow_shelf_scene:
		shadow_shelf_scene.queue_free()
		shadow_shelf_scene = null

func start_placing_checkout() -> void:
	is_placing_checkout = true
	shadow_checkout_scene = preload("res://scenes/checkout/ShadowCheckout.tscn").instantiate()
	add_child(shadow_checkout_scene)

func stop_placing_checkout() -> void:
	is_placing_checkout = false
	if shadow_checkout_scene:
		shadow_checkout_scene.queue_free()
		shadow_checkout_scene = null

func update_shadow_color(is_valid: bool):
	if shadow_shelf_scene:
		var color = Color(0, 1, 0, 0.4) \
			if is_valid \
			else Color(1, 0, 0, 0.4)
		if shadow_shelf_scene.has_node("Sprite"):
			shadow_shelf_scene.get_node("Sprite").modulate = color
	
	if shadow_checkout_scene:
		var color = Color(0, 1, 0, 0.4) \
			if is_valid \
			else Color(1, 0, 0, 0.4)
		if shadow_checkout_scene.has_node("Sprite"):
			shadow_checkout_scene.get_node("Sprite").modulate = color
