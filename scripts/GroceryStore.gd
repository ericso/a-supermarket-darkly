extends Node2D

var shelves: Array[Node2D] = []

func register_shelf(shelf: Node2D) -> void:
	if not shelves.has(shelf):
		shelves.append(shelf)

func unregister_shelf(shelf: Node2D) -> void:
	shelves.erase(shelf)

func get_stocked_shelves() -> Array[Node2D]:
	return shelves.filter(func(shelf): return shelf.has_stock())

func get_random_stocked_shelf() -> Node2D:
	var stocked = get_stocked_shelves()
	if stocked.is_empty():
		return null
	return stocked[randi() % stocked.size()]

# TODO consider implementation
#var checkout_node: Node2D
#func get_checkout_position() -> Vector2i:
	#return checkout_node.global_position if checkout_node else Vector2.ZERO
