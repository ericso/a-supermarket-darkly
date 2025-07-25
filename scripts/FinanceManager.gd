extends Node

# bank is how much money the grocery store has
var bank: float = 100.0 # start off the game with $100

# profits maps item ids to the amount profit for that item
var profits: Dictionary = {}

func get_current_bank() -> float:
	return bank

func record_purchase(item_id: String, qty: int):
	var item: Item = ItemDatabase.get_item(item_id)
	var spent: float = qty * item.unit_price
	if !profits.has(item_id):
		profits[item_id] = {
			"spent": spent,
			"earned": 0,
		}
	else:
		profits[item_id].spent += spent

func record_sale(item_id: String, qty: int):
	var item: Item = ItemDatabase.get_item(item_id)
	var earned: float = qty * item.sale_price
	if !profits.has(item_id):
		profits[item_id] = {
			"spent": 0,
			"earned": earned,
		}
	else:
		profits[item_id].earned += earned
