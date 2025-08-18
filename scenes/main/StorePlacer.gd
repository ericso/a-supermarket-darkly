extends Node2D

@onready var store_panel: VBoxContainer = get_parent().get_node("UI/SideMenu/MarginContainer/VBoxContainer/StorePanel")

@onready var shelf_scene = preload("res://scenes/shelf/Shelf.tscn")
var shadow_shelf_scene: Node2D = null
var is_placing_shelf: bool = false

@onready var checkout_scene = preload("res://scenes/checkout/Checkout.tscn")
var shadow_checkout_scene: Node2D = null

@onready var store_map: TileMapLayer = get_parent().get_node("Store")
@onready var nav_region: NavigationRegion2D = get_parent().get_node("NavigationRegion")
var is_placing_checkout: bool = false

func _ready() -> void:
	store_panel.connect("place_shelf_button_pressed", self.on_place_shelf_pressed)
	store_panel.connect("place_checkout_button_pressed", self.on_place_checkout_pressed)
	store_panel.connect("back_button_pressed", self.terminate_all_placing_modes)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if is_placing_shelf:
			var tile_pos = store_map.local_to_map(event.position)
			if can_place_node_at(tile_pos):
				place_shelf_at(tile_pos)
		if is_placing_checkout:
			var tile_pos = store_map.local_to_map(event.position)
			if can_place_node_at(tile_pos):
				place_checkout_at(tile_pos)

func _process(_delta) -> void:
	if is_placing_shelf and shadow_shelf_scene: 
		var mouse_pos = get_global_mouse_position()
		var tile_pos: Vector2i = store_map.local_to_map(mouse_pos)
		var snapped_pos = store_map.map_to_local(tile_pos)
		shadow_shelf_scene.position = snapped_pos
		update_shadow_color(can_place_node_at(tile_pos))
	
	if is_placing_checkout and shadow_checkout_scene: 
		var mouse_pos = get_global_mouse_position()
		var tile_pos: Vector2i = store_map.local_to_map(mouse_pos)
		var snapped_pos = store_map.map_to_local(tile_pos)
		shadow_checkout_scene.position = snapped_pos
		update_shadow_color(can_place_node_at(tile_pos))

func on_place_shelf_pressed():
	if is_placing_checkout:
		stop_placing_checkout()
	
	if is_placing_shelf:
		stop_placing_shelf()
	else:
		start_placing_shelf()

func on_place_checkout_pressed():
	if is_placing_shelf:
		stop_placing_shelf()
	
	if is_placing_checkout:
		stop_placing_checkout()
	else:
		start_placing_checkout()
		
func terminate_all_placing_modes() -> void:
	stop_placing_shelf()
	stop_placing_checkout()

func can_place_node_at(tile_pos: Vector2i) -> bool:
	var world_pos = store_map.map_to_local(tile_pos)

	for shelf in get_tree().get_nodes_in_group("shelves"):
		if shelf.position == world_pos:
			return false

	for checkout in get_tree().get_nodes_in_group("checkouts"):
		if checkout.position == world_pos:
			return false

	for customer in get_tree().get_nodes_in_group("customers"):
		if customer.global_position.distance_to(world_pos) < 16.0:
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
	store_panel.set_place_shelf_mode_enabled(true)

func stop_placing_shelf() -> void:
	is_placing_shelf = false
	if shadow_shelf_scene:
		shadow_shelf_scene.queue_free()
		shadow_shelf_scene = null
	store_panel.set_place_shelf_mode_enabled(false)

func start_placing_checkout() -> void:
	is_placing_checkout = true
	shadow_checkout_scene = preload("res://scenes/checkout/ShadowCheckout.tscn").instantiate()
	add_child(shadow_checkout_scene)
	store_panel.set_place_checkout_mode_enabled(true)

func stop_placing_checkout() -> void:
	is_placing_checkout = false
	if shadow_checkout_scene:
		shadow_checkout_scene.queue_free()
		shadow_checkout_scene = null
	store_panel.set_place_checkout_mode_enabled(false)

func update_shadow_color(can_place: bool):
	var color_placeable := Color(0.0, 1.0, 0.0, 0.7)  # Bright green, semi-transparent
	var color_blocked := Color(1.0, 0.0, 0.0, 0.7)   # Bright red, semi-transparent

	var color := color_placeable if can_place else color_blocked

	if shadow_shelf_scene:
		var sprite = shadow_shelf_scene.get_node_or_null("Sprite")
		if sprite:
			sprite.self_modulate = color

	if shadow_checkout_scene:
		var sprite = shadow_checkout_scene.get_node_or_null("Sprite")
		if sprite:
			sprite.self_modulate = color
