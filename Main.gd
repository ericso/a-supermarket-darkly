extends Node2D

@onready var background := $Background
const TILE_ID = Vector2i(0, 0)
const TILE_SIZE = 32

var ShelfScene := preload("res://Shelf.tscn")

func _ready():
	var screen_size = get_viewport_rect().size
	var tiles_x = int(ceil(screen_size.x / TILE_SIZE))
	var tiles_y = int(ceil(screen_size.y / TILE_SIZE))
	
	for x in tiles_x:
		for y in tiles_y:
			background.set_cell(Vector2i(x, y), 0, TILE_ID)
	
	place_shelf_at_tile(5, 10)

func place_shelf_at_tile(x_tile: int, y_tile: int):
	var shelf = ShelfScene.instantiate()
	var world_pos = Vector2(x_tile, y_tile) * TILE_SIZE
	shelf.position = world_pos
	add_child(shelf)
