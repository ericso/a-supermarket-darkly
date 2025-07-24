extends Node

const TILE_SIZE: int = 32
const FRONT_DOOR_LOCATION: Vector2 = Vector2(8, 18)

var customer_scene := preload("res://scenes/customer/Customer.tscn")
var customer_sprites: Array[Resource] = [
	preload("res://assets/sprites/characters/man.png"),
	preload("res://assets/sprites/characters/woman.png"),
]

@export var spawn_interval: float = 3.0 # seconds

var spawn_timer: Timer = null

func _ready():
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.autostart = true
	spawn_timer.timeout.connect(spawn_customer)
	add_child(spawn_timer)

func spawn_customer():
	var customer = customer_scene.instantiate()
	customer.sprite_texture = customer_sprites[randi() % customer_sprites.size()]
	
	var world_pos = FRONT_DOOR_LOCATION * TILE_SIZE
	customer.position = world_pos
	
	add_child(customer)
