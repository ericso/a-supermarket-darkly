extends MarginContainer

@onready var reserves_label = $StatsContainer/Reserves
@onready var customers_served_label = $StatsContainer/CustomersServed
@onready var customers_disappointed_label = $StatsContainer/CustomersDisappointed
@onready var profit_label = $StatsContainer/TotalProfit

@onready var profit_container = $StatsContainer/MarginContainer/ProfitContainer

func _process(_delta: float) -> void:
	update_labels()
	
func update_labels():
	reserves_label.text = "Reserves: $%.2f" % FinanceManager.reserves
	customers_served_label.text = "Customers Served: %d" % FinanceManager.customers_served
	customers_disappointed_label.text = "Customers Disappointed: %d" % FinanceManager.customers_disappointed
	profit_label.text = "Total Profit: $%.2f" % FinanceManager.get_total_profit()
	update_profit_container()

func update_profit_container():
	clear_labels()
	for product_id in InventoryManager.get_inventory_ids():
		var product: Product = ProductDatabase.get_product(product_id)
		add_label("%s: Sold: %d | Profit: $%.2f | Missed Sales: %d" % [
			product.label, 
			InventoryManager.get_sold_count(product_id), 
			FinanceManager.get_profit_for_product(product_id),
			FinanceManager.get_missed_sales_for_product(product_id),
		])

func add_label(text: String):
	var new_label = Label.new()
	new_label.text = text
	profit_container.add_child(new_label)

func clear_labels():
	for child in profit_container.get_children():
		child.queue_free()
