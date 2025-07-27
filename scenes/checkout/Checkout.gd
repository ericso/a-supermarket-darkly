class_name Checkout extends Node2D

func _ready():
	StoreManager.register_checkout(self)

func checkout_product(product: Product, qty: int):
	var cost: float = product.sale_price * qty
	NotificationManager.add_notification("checkout_product {id} {price} {qty} {cost}".format({
		"id": product.id,
		"price": product.sale_price,
		"qty": qty,
		"cost": cost,
	}))
	FinanceManager.reserves += cost
	InventoryManager.sell_product(product.id, qty)

func checkout_basket(basket: Dictionary):
	for _product in basket:
		checkout_product(_product, basket[_product])
	FinanceManager.customers_served += 1
