extends Node2D

@onready var store_map: TileMapLayer = $Store
@onready var nav_region: NavigationRegion2D = $NavigationRegion
@onready var shelf_scene = preload("res://scenes/shelf/Shelf.tscn")

# shadow_shelf_scene is used to show where a shelf will be placed
var shadow_shelf_scene: Node2D = null
var is_placing_shelf: bool = false

func _ready() -> void:
	spawn_interactables()
	
	InventoryManager.populate_inventory()
	
	$UI.connect("place_shelf_mode_activated", self.on_place_shelf_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if is_placing_shelf and event is InputEventMouseButton and event.pressed:
		var tile_pos = store_map.local_to_map(event.position)
		if can_place_shelf_at(tile_pos):
			place_shelf_at(tile_pos)

func _process(delta) -> void:
	if is_placing_shelf and shadow_shelf_scene:
		var mouse_pos = get_global_mouse_position()
		var tile_pos: Vector2i = store_map.local_to_map(mouse_pos)
		var snapped_pos = store_map.map_to_local(tile_pos)
		shadow_shelf_scene.position = snapped_pos
		
		update_shadow_color(can_place_shelf_at(snapped_pos))

# spawn_interactables instantiates all "interactable" tiles
func spawn_interactables():
	if store_map == null:
		push_error("store tilemaplayer node not found")
	
	for cell in store_map.get_used_cells():
		var tile_data = store_map.get_cell_tile_data(cell)
		if tile_data and tile_data.get_custom_data("interactable"):
			var scene_path := tile_data.get_custom_data("scene_path") as String
			if scene_path != "":
				var packed_scene := load(scene_path)
				if packed_scene:
					var node = packed_scene.instantiate()
					node.position = store_map.map_to_local(cell)
					add_child(node)
					node.name = tile_data.get_custom_data("name")
				else:
					push_error("⚠️ Could not load scene at path: ", scene_path)

func on_place_shelf_pressed():
	if is_placing_shelf:
		stop_placing_shelf()
	else:
		start_placing_shelf()

func can_place_shelf_at(tile_pos: Vector2i) -> bool:
	var world_pos = store_map.map_to_local(tile_pos)
	for child in get_children():
		if child is Shelf and child.position == world_pos:
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

func start_placing_shelf() -> void:
	is_placing_shelf = true
	shadow_shelf_scene = preload("res://scenes/shelf/ShadowShelf.tscn").instantiate()
	add_child(shadow_shelf_scene)
	Input.set_default_cursor_shape(Input.CURSOR_CROSS)

func stop_placing_shelf() -> void:
	is_placing_shelf = false
	if shadow_shelf_scene:
		shadow_shelf_scene.queue_free()
		shadow_shelf_scene = null

func update_shadow_color(is_valid: bool):
	if shadow_shelf_scene:
		var color = Color(0, 1, 0, 0.4) \
			if is_valid \
			else Color(1, 0, 0, 0.4)
		if shadow_shelf_scene.has_node("Sprite"):
			shadow_shelf_scene.get_node("Sprite").modulate = color
