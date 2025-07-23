class_name Checkout extends Node2D

func _ready():
	GroceryStore.register_checkout(self)

func checkout_item(item: Item, qty: int):
	var cost: float = item.price * qty
	print("DEBUG::checkout_item {id} {price} {qty} {cost}".format({
		"id": item.id,
		"price": item.price,
		"qty": qty,
		"cost": cost,
	}))
	GroceryStore.bank += cost
