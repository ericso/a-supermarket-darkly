extends MarginContainer

@onready var customers_served_label = $VBoxContainer/CustomersServed
@onready var profit_label = $VBoxContainer/Profit
@onready var reserves_label = $VBoxContainer/Reserves

func _process(delta: float) -> void:
	update_labels()
	
func update_labels():
	customers_served_label.text = "Customers Served: %d" % FinanceManager.customers_served
	# TODO implment profit calculation
	profit_label.text = "Profit: %d" % FinanceManager.reserves
	reserves_label.text = "Profit: %d" % FinanceManager.reserves
