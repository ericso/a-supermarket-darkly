extends Node

var customer_scene := preload("res://scenes/customer/Customer.tscn")
var customer_sprites: Array[Resource] = [
	preload("res://assets/sprites/characters/man.png"),
	preload("res://assets/sprites/characters/woman.png"),
]

@export var tilemap_path: NodePath = ^"../Store"
@onready var tilemap := get_node(tilemap_path)

@export var spawn_interval: float = 3.0 # seconds

var spawn_timer: Timer = null
var spawn_positions: Array[Vector2] = []

func _ready():
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.autostart = true
	spawn_timer.timeout.connect(spawn_customer)
	add_child(spawn_timer)
	
	spawn_positions = get_spawn_positions(tilemap)

func get_spawn_positions(tilemap: TileMapLayer) -> Array[Vector2]:
	var spawn_positions: Array[Vector2] = []
	for cell in tilemap.get_used_cells():
		var tile_data = tilemap.get_cell_tile_data(cell)
		if tile_data and tile_data.get_custom_data("spawn") == true:
			spawn_positions.append(tilemap.map_to_local(cell))
	return spawn_positions

func spawn_customer():
	if spawn_positions.is_empty():
		push_error("no customer spawn tiles found")
		return
	
	var customer = customer_scene.instantiate()
	customer.sprite_texture = customer_sprites.pick_random()
	customer.position = spawn_positions.pick_random()
	add_child(customer)
