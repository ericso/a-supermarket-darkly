class_name Checkout extends Node2D

func _ready():
	StoreManager.register_checkout(self)

func checkout_item(item: Item, qty: int):
	var cost: float = item.sale_price * qty
	FinanceManager.bank += cost
	FinanceManager.customers_served += 1
	InventoryManager.sell_item(item, qty)
