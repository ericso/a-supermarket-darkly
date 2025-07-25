extends Node

var products = {
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

func get_product(id: String) -> Item:
	var data = ProductDatabase.get_product_data(id)
	return Item.new(
		data.id,
		data.name,
		data.sale_price,
		data.texture,
		data.unit_price,
	)

func get_product_data(id: String) -> Dictionary:
	return products.get(id, {})

func get_product_ids() -> Array:
	return products.keys()

func get_product_count() -> int:
	return get_product_ids().size()
