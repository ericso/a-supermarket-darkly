class_name Shelf extends Node2D

# Item handling
@export var item: Item = null # the item this shelf holds
@onready var item_sprite := $ItemSprite
@onready var stock_bar: ProgressBar = $StockBar
@export var max_stock: int = 10
var current_stock: int = 0

@export var min_item_purchase_count: int = 1
@export var max_item_purchase_count: int = 4

# Interaction handling
@onready var tap_hold_timer: Timer = $TapHoldTimer
var is_mouse_over = false
var is_holding = false
var hold_threshold = 0.3 # seconds to register hold

func _ready():
	GroceryStore.register_shelf(self)
	
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

func get_item() -> Item:
	return item

# pick_random_qty reduces the shelf by a random amount between the min and max
# item purchase counts. If the pick reduces the stock to zero, the available
# stock is picked. The amount picked is returned.
func pick_random_qty() -> int:
	if item == null:
		return 0
	
	if current_stock == 0:
		return 0
	
	var amt: int = RandomNumberGenerator.new().randi_range(min_item_purchase_count, max_item_purchase_count)
	if current_stock - amt < 0:
		amt = current_stock
	current_stock -= amt
	update_stock_bar()
	return amt

# stock_with_item sets this shelf to the item id
func stock_with_item(id: String):
	var item_data = ItemDatabase.get_item_data(id)
	item = Item.new(
		item_data.id,
		item_data.name,
		item_data.price,
		item_data.texture,
	)
	item_sprite.texture = item_data.texture
	restock()
	update_stock_bar()

# restock sets current_stock to max
func restock():
	current_stock = max_stock
	update_stock_bar()

func has_stock() -> bool:
	return !item == null and current_stock != 0

func update_stock_bar():
	stock_bar.value = current_stock
