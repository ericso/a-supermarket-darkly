extends Node

# reserves is how much money the grocery store has
var reserves: float = 100.0 # start off the game with $100

# profits maps product ids to the amount profit for that product.
# spent: money spent to purchase units of product
# earned: money earned from customer purchases
# {
#     "product_id": {
#         "spent": float,
#         "earned": float,
#     },
# }
var profits: Dictionary[String, Dictionary] = {}

# customers_served is a count of all customers that have checked out
var customers_served: int = 0

# customers_disappointed is a count of all customers that have left without buying something
var customers_disappointed: int = 0

# missed_sales stores a count of missed sales for each product_id
var missed_sales: Dictionary[String, int] = {}

func record_purchase(product_id: String, qty: int):
	var product: Product = ProductDatabase.get_product(product_id)
	var spent: float = qty * product.unit_price
	if !profits.has(product_id):
		profits[product_id] = {
			"spent": spent,
			"earned": 0,
		}
	else:
		profits[product_id].spent += spent

func record_sale(product_id: String, qty: int):
	var product: Product = ProductDatabase.get_product(product_id)
	var earned: float = qty * product.sale_price
	if !profits.has(product_id):
		profits[product_id] = {
			"spent": 0,
			"earned": earned,
		}
	else:
		profits[product_id].earned += earned

func record_missed_sale(product_id: String):
	if !missed_sales.has(product_id):
		missed_sales[product_id] = 1
	else:
		missed_sales[product_id] += 1

func get_profit_for_product(product_id) -> float:
	if !profits.has(product_id):
		return 0.00
	return profits[product_id].earned - profits[product_id].spent

func get_total_profit() -> float:
	var total_profit: float = 0.0
	for product_id in ProductDatabase.get_product_ids():
		total_profit += get_profit_for_product(product_id)
	return total_profit
