class_name Checkout extends Node2D

func _ready():
	StoreManager.register_checkout(self)

func checkout_product(product: Product, qty: int):
	var cost: float = product.sale_price * qty
	print("DEBUG::checkout_product {id} {price} {qty} {cost}".format({
		"id": product.id,
		"price": product.sale_price,
		"qty": qty,
		"cost": cost,
	}))
	FinanceManager.bank += cost
	InventoryManager.sell_product(product, qty)
