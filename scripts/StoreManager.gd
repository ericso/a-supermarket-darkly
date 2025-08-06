extends Node

var shelves: Array[Shelf] = []
var checkouts: Array[Checkout] = []
var front_door: Door = null

## Shelves
func register_shelf(shelf: Shelf) -> void:
	if not shelves.has(shelf):
		shelves.append(shelf)

func unregister_shelf(shelf: Shelf) -> void:
	shelves.erase(shelf)

# get_stocked_shelves returns an array of all stocked shelves
# Array is empty if no shelves are stocked
func get_stocked_shelves() -> Array[Shelf]:
	return shelves.filter(func(shelf: Shelf): return shelf.has_stock())

func get_random_stocked_shelf() -> Shelf:
	var stocked = get_stocked_shelves()
	if stocked.is_empty():
		return null
	return stocked[randi() % stocked.size()]

# get_shelf_for_product_id returns an array of stocked shelves of Product with
# product_id. Array is empty if there are no shelves with this criteria.
func get_shelf_for_product_id(product_id: String) -> Array[Shelf]:
	var shelves_for_product_id: Array[Shelf] = shelves.filter(
		func(shelf: Shelf):
			var candidate = shelf.get_product()
			return candidate != null and candidate.id == product_id
	)
	return shelves_for_product_id.filter(func(shelf: Shelf): return shelf.has_stock())

## Checkouts
func register_checkout(checkout: Checkout) -> void:
	if not checkouts.has(checkout):
		checkouts.append(checkout)

func unregister_checkout(checkout: Checkout) -> void:
	checkouts.erase(checkout)

func get_open_checkout() -> Checkout:
	if checkouts.size() == 0:
		return null
	return checkouts[randi() % checkouts.size()]

## Doors
func register_door(door: Door) -> void:
	front_door = door

func get_front_door() -> Door:
	return front_door
