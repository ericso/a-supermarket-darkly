extends Node2D

@onready var background := $Background
const TILE_ID = Vector2i(0, 0)
const TILE_SIZE = 32

var shelf_scene := preload("res://scenes/shelf/Shelf.tscn")
var customer_scene := preload("res://scenes/customer/Customer.tscn")

func _ready():
	var screen_size = get_viewport_rect().size
	var tiles_x = int(ceil(screen_size.x / TILE_SIZE))
	var tiles_y = int(ceil(screen_size.y / TILE_SIZE))
	
	for x in tiles_x:
		for y in tiles_y:
			background.set_cell(Vector2i(x, y), 0, TILE_ID)
	
	# spawn shelves and customers
	# TODO for testing
	place_shelf_at_tile(1, 8)
	place_shelf_at_tile(2, 8)
	spawn_customer_at_tile(10, 10)

func place_shelf_at_tile(x_tile: int, y_tile: int):
	var shelf = shelf_scene.instantiate()
	var world_pos = Vector2(x_tile, y_tile) * TILE_SIZE
	shelf.position = world_pos
	add_child(shelf)

func spawn_customer_at_tile(x_tile: int, y_tile: int):
	var customer = customer_scene.instantiate()
	customer.sprite_texture = preload("res://assets/sprites/characters/man.png")
	
	var world_pos = Vector2(x_tile, y_tile) * TILE_SIZE
	customer.position = world_pos
	
	add_child(customer)
