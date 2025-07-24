extends Node

var items = {
	"apple": {
		"id": "apple",
		"name": "Apple",
		"price": 0.5,
		"texture": preload("res://assets/sprites/items/apple.png")
	},
	"cereal": {
		"id": "cereal",
		"name": "Cereal",
		"price": 3.95,
		"texture": preload("res://assets/sprites/items/cereal.png")
	},
	"fish": {
		"id": "fish",
		"name": "Fish",
		"price": 7.88,
		"texture": preload("res://assets/sprites/items/fish.png")
	},
	"steak": {
		"id": "steak",
		"name": "Steak",
		"price": 19.01,
		"texture": preload("res://assets/sprites/items/steak.png")
	},
}

func get_item_data(id: String) -> Dictionary:
	return items.get(id, {})

func get_item_ids() -> Array:
	return items.keys()

func get_item_count() -> int:
	return get_item_ids().size()
