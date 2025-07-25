extends CharacterBody2D

@export var speed := 300.0

# min and max products is the range of unique products which the customer
# will attempt to purchase
@export var min_products := 1
@export var max_products := ProductDatabase.get_product_count()

@onready var sprite := $Sprite

@export var sprite_texture: Texture2D
@onready var nav_agent := $NavigationAgent

var basket: Dictionary = {}
var num_products_to_buy: int = 0
var visited_shelves: Dictionary = {}

# seconds to wait before re-trying for a stocked shelf
const CUSTOMER_WAIT_INTERVAL: float = 0.5

func _ready():
	num_products_to_buy = RandomNumberGenerator.new().randi_range(min_products, max_products)
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
	print("DEBUG::run_customer_loop num_products_to_buy ", num_products_to_buy)
	while num_products_to_buy > 0:
		var shelf: Shelf = StoreManager.get_random_stocked_shelf()
		if shelf == null or visited_shelves.has(shelf.get_product().id):
			await get_tree().create_timer(CUSTOMER_WAIT_INTERVAL).timeout
			continue
		
		set_target_position(shelf.global_position)
		await nav_agent.target_reached
		visited_shelves[shelf.get_product().id] = null
		basket[shelf.get_product()] = shelf.pick_random_qty()
		num_products_to_buy -= 1
	
	var checkout: Checkout = StoreManager.get_open_checkout()
	set_target_position(checkout.global_position)
	await nav_agent.target_reached
	checkout.checkout_basket(basket)
	
	var front_door: Door = StoreManager.get_front_door()
	set_target_position(front_door.global_position)
	await nav_agent.target_reached
	print("goodbye!")
	queue_free()

func set_target_position(pos: Vector2) -> void:
	var map = nav_agent.get_navigation_map()
	var safe_pos = NavigationServer2D.map_get_closest_point(map, pos)

	# Clear the current target if needed
	nav_agent.set_target_position(Vector2.ZERO)
	await get_tree().process_frame  # allow one frame to clear internal state
	nav_agent.set_target_position(safe_pos)
