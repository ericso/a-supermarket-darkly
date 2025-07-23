extends Node

var apple = Item.new("apple", "Apple", 1, preload("res://assets/sprites/items/apple.png"))
var cereal = Item.new("cereal", "Cereal", 3, preload("res://assets/sprites/items/cereal.png"))

var items = {
	"apple": apple,
	"cereal": cereal,
}

func get_item_data(id: String) -> Item:
	return items.get(id, {})

func get_item_ids() -> Array:
	return items.keys()
