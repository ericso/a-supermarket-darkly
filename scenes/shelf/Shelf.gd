class_name Shelf extends Node2D

# Product handling
@export var product: Product = null # the Product this shelf holds
@onready var product_sprite := $ProductSprite
@onready var stock_bar: ProgressBar = $StockBar
@export var max_stock: int = 20
var current_stock: int = 0

@export var min_product_purchase_count: int = 1
@export var max_product_purchase_count: int = 4

# Interaction handling
@onready var tap_hold_timer: Timer = $TapHoldTimer
var is_mouse_over = false
var is_holding = false
var hold_threshold = 0.3 # seconds to register hold

func _ready():
	StoreManager.register_shelf(self)
	
	connect("mouse_entered", on_mouse_entered)
	connect("mouse_exited", on_mouse_exited)
	tap_hold_timer.wait_time = hold_threshold
	tap_hold_timer.one_shot = true
	tap_hold_timer.timeout.connect(on_hold)
	
	stock_bar.max_value = max_stock
	stock_bar.value = current_stock
	stock_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and is_mouse_over:
			is_holding = false
			tap_hold_timer.start()
		elif not event.pressed and is_mouse_over:
			if tap_hold_timer.time_left > 0:
				tap_hold_timer.stop()
				restock()

func on_mouse_entered():
	is_mouse_over = true

func on_mouse_exited():
	is_mouse_over = false
	tap_hold_timer.stop()

func on_hold():
	is_holding = true
	open_shelf_menu()

func open_shelf_menu():
	var menu = preload("res://scenes/shelf_menu/ShelfMenu.tscn").instantiate()
	get_tree().current_scene.add_child(menu)
	menu.popup()
	menu.position = get_viewport().get_mouse_position()
	menu.shelf = self

func get_product() -> Product:
	return product

# pick_random_qty reduces the shelf by a random amount between the min and max
# product purchase counts. If the pick reduces the stock to zero, the available
# stock is picked. The amount picked is returned.
func pick_random_qty() -> int:
	if product == null:
		return 0
	
	if current_stock == 0:
		return 0
	
	var amt: int = RandomNumberGenerator.new().randi_range(min_product_purchase_count, max_product_purchase_count)
	if current_stock - amt < 0:
		amt = current_stock
	current_stock -= amt
	update_stock_bar()
	return amt

# stock_with_product stocks this shelf with the Product of id
func stock_with_product(id: String):
	product = ProductDatabase.get_product(id)
	product_sprite.texture = product.texture
	restock()
	update_stock_bar()

# restock tries to set the current stock to max_stock
func restock():
	if product == null:
		print("unable to restock, shelf has no product") # TODO notification center
		return
	
	var amount_to_stock: int = max_stock - current_stock
	var amt_stocked: int = InventoryManager.move_stock_to_shelf(product.id, amount_to_stock)
	current_stock += amt_stocked
	update_stock_bar()

func has_stock() -> bool:
	return !product == null and current_stock != 0

func update_stock_bar():
	stock_bar.value = current_stock
