extends CharacterBody2D

@export var speed := 50.0
@export var shelf_wait_time: float = 2.0
@export var checkout_wait_time: float = 4.0

# min and max products is the range of unique products which the customer
# will attempt to purchase
@export var min_products := 1
@export var max_products := ProductDatabase.get_product_count()

# min and max purchase amounts are the range of units of product a customer
# will attempt to buy for each product
@export var min_purchase_amount := 1
@export var max_purchase_amount := 4

@onready var sprite := $Sprite

@export var sprite_texture: Texture2D
@onready var nav_agent := $NavigationAgent

@onready var notification_label: Label = $FloatingUI/NotificationLabel

var basket: Dictionary = {}
var products_wanted: Array[String] = []

# seconds to wait before re-trying for a stocked shelf
const CUSTOMER_WAIT_INTERVAL: float = 0.5

func _ready():
	products_wanted = get_wanted_products()
	sprite.texture = sprite_texture
	run_customer_loop()

func _physics_process(_delta):
	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
	else:
		var next_pos = nav_agent.get_next_path_position()
		var direction = (next_pos - global_position).normalized()
		velocity = direction * speed
	move_and_slide()

func run_customer_loop() -> void:
	add_floating_notification("need to buy %d things" % products_wanted.size())
	
	var product_id: String = ""
	while !products_wanted.is_empty():
		product_id = products_wanted.pop_front()
		var shelves_for_product = StoreManager.get_shelf_for_product_id(product_id)
		if shelves_for_product.size() == 0:
			# no available shelves with product_id, move on
			NotificationManager.add_notification("no shelves with prouduct %s" % product_id)
			add_floating_notification("can't find %s" % product_id)
			FinanceManager.record_missed_sale(product_id)
			continue
		
		# just take the first shelf
		var target_shelf: Shelf = shelves_for_product[0]
		set_target_position(target_shelf.global_position)
		await nav_agent.target_reached
		await wait_at_location(shelf_wait_time)
		basket[target_shelf.get_product()] = target_shelf.pick_quantity(randi_range(min_purchase_amount, max_purchase_amount))
	
	var checkout: Checkout = StoreManager.get_open_checkout()
	set_target_position(checkout.global_position)
	await nav_agent.target_reached
	await wait_at_location(checkout_wait_time)
	checkout.checkout_basket(basket)
	
	var front_door: Door = StoreManager.get_front_door()
	set_target_position(front_door.global_position)
	await nav_agent.target_reached
	queue_free()

func set_target_position(pos: Vector2) -> void:
	var map = nav_agent.get_navigation_map()
	var safe_pos = NavigationServer2D.map_get_closest_point(map, pos)

	# Clear the current target if needed
	nav_agent.set_target_position(Vector2.ZERO)
	await get_tree().process_frame  # allow one frame to clear internal state
	nav_agent.set_target_position(safe_pos)

# get_wanted_products returns a random number of available product ids
func get_wanted_products() -> Array[String]:
	var available_product_ids: Array[String] = ProductDatabase.get_product_ids()
	available_product_ids.shuffle()
	return available_product_ids.slice(0, randi_range(min_products, max_products))

func wait_at_location(time: float):
	await get_tree().create_timer(time).timeout

# add_floating_notification displays the provided message above the customer sprite
# for the given duration. The label used is not despawned, but the text is cleared.
func add_floating_notification(message: String, duration: float = 5.0):
	notification_label.text = message
	
	var tween = notification_label.create_tween()
	tween.tween_interval(duration)
	tween.tween_property(notification_label, "modulate:a", 0.0, 0.5)
	tween.finished.connect(func():
		if is_instance_valid(notification_label):
			notification_label.text = ""
	)
