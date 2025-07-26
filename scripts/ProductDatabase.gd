extends Node

var products = {}

func _ready():
	var to_process = load_products_from_json("res://data/products.json")
	for p in to_process:
		products[p["id"]] = {
			"id": p["id"],
			"name": p["name"],
			"sale_price": p["sale_price"],
			"unit_price": p["unit_price"],
			"texture": load(p["icon_path"]),
		}
		

func load_products_from_json(path: String) -> Array:
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var result = JSON.parse_string(content)
		if typeof(result) == TYPE_DICTIONARY and result.has("products"):
			return result["products"]
		else:
			push_error("invalid JSON structure in products file")
	else:
		push_error("failed to open file: " + path)
	return []

func get_product(id: String) -> Product:
	var data = ProductDatabase.get_product_data(id)
	return Product.new(
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
