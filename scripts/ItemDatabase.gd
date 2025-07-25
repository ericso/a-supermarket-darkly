extends Node

var items = {
	"apple": {
		"id": "apple",
		"name": "Apple",
		"sale_price": 0.5,
		"texture": preload("res://assets/sprites/items/apple.png"),
		"unit_price": 0.1,
	},
	"cereal": {
		"id": "cereal",
		"name": "Cereal",
		"sale_price": 3.95,
		"texture": preload("res://assets/sprites/items/cereal.png"),
		"unit_price": 0.1,
	},
	"fish": {
		"id": "fish",
		"name": "Fish",
		"sale_price": 7.88,
		"texture": preload("res://assets/sprites/items/fish.png"),
		"unit_price": 0.1,
	},
	"steak": {
		"id": "steak",
		"name": "Steak",
		"sale_price": 19.01,
		"texture": preload("res://assets/sprites/items/steak.png"),
		"unit_price": 0.1,
	},
}

func get_item(id: String) -> Item:
	var item_data = ItemDatabase.get_item_data(id)
	return Item.new(
		item_data.id,
		item_data.name,
		item_data.sale_price,
		item_data.texture,
		item_data.unit_price,
	)

func get_item_data(id: String) -> Dictionary:
	return items.get(id, {})

func get_item_ids() -> Array:
	return items.keys()

func get_item_count() -> int:
	return get_item_ids().size()
