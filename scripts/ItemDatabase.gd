extends Node

var items = {
	"apple": {
		"name": "Apple",
		"price": 1,
		"texture": preload("res://assets/apple.png")
	},
	"cereal": {
		"name": "Cereal",
		"price": 10,
		"texture": preload("res://assets/cereal.png")
	},
}

func get_item_data(id: String) -> Dictionary:
	return items.get(id, {})

func get_item_ids() -> Array:
	return items.keys()
