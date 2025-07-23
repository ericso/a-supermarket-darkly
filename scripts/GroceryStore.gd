extends Node2D

var shelves: Array[Shelf] = []

# bank is how much money the grocery store has
var bank: float = 0.0

func register_shelf(shelf: Shelf) -> void:
	if not shelves.has(shelf):
		shelves.append(shelf)

func unregister_shelf(shelf: Shelf) -> void:
	shelves.erase(shelf)

func get_stocked_shelves() -> Array[Shelf]:
	return shelves.filter(func(shelf): return shelf.has_stock())

func get_random_stocked_shelf() -> Shelf:
	var stocked = get_stocked_shelves()
	if stocked.is_empty():
		return null
	return stocked[randi() % stocked.size()]

func get_current_bank() -> float:
	return bank
