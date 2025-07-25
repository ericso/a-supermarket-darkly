extends Node

var shelves: Array[Shelf] = []
var checkouts: Array[Checkout] = []
var front_door: Door = null

# bank is how much money the grocery store has
var bank: float = 100.0 # start off the game with $100

# items_sold keys are Item objects, value is the amount of that item sold
var items_sold: Dictionary = {}
	
func record_item_sold(item: Item, qty: int):
	if !items_sold.has(item):
		items_sold[item] = qty
	else:
		items_sold[item] += qty

func get_current_bank() -> float:
	return bank

## Shelves
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

## Checkouts
func register_checkout(checkout: Checkout) -> void:
	if not checkouts.has(checkout):
		checkouts.append(checkout)

func unregister_checkout(checkout: Checkout) -> void:
	checkouts.erase(checkout)

func get_open_checkout() -> Checkout:
	return checkouts[randi() % checkouts.size()]

## Doors
func register_door(door: Door) -> void:
	front_door = door

func get_front_door() -> Door:
	return front_door
