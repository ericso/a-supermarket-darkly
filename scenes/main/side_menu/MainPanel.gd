extends VBoxContainer

@onready var money_label := $MoneyLabel

func _process(_delta) -> void:
	update_money_label()

func update_money_label():
	money_label.text = "Money: $%0.2f" % FinanceManager.reserves
