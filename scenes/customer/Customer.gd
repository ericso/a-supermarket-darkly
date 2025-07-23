extends CharacterBody2D

@export var speed := 300.0

@onready var sprite := $Sprite

@export var sprite_texture: Texture2D
@onready var nav_agent := $NavigationAgent

var basket: Array[Item] = []

func _ready():
	sprite.texture = sprite_texture
	visit_random_stocked_shelf()

# visit_random_stocked_shelf will pick a randomly stocked shelf, and navigate
# the customer to that shelf. If there are no stocked shelves, the customer will
# remain motionless and try again in 1 second.
func visit_random_stocked_shelf():
	var shelf: Shelf = GroceryStore.get_random_stocked_shelf()
	if shelf:
		var map = nav_agent.get_navigation_map()
		var target_pos = shelf.global_position
		var safe_pos = NavigationServer2D.map_get_closest_point(map, target_pos)
		nav_agent.set_target_position(safe_pos)
		
		# Disconnect any previous connection made
		if nav_agent.is_connected("target_reached", Callable(self, "_on_reached_shelf")):
			nav_agent.target_reached.disconnect(Callable(self, "_on_reached_shelf"))
		# Use a lambda to capture the shelf
		nav_agent.target_reached.connect(func(): _on_reached_shelf(shelf), CONNECT_ONE_SHOT)
	else:
		await get_tree().create_timer(1.0).timeout
		visit_random_stocked_shelf()

func fill_basket_from_shelf(item_id: String, qty: int):
	print("DEBUG::fill_basket_from_shelf id: {item_id} amount: {qty}".format({"item_id": item_id, "qty": qty}))
	# TODO fill the basket

func _physics_process(_delta):
	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		# TODO the customer should visit some random amount of shelves
		# then go to checkout
		#visit_random_stocked_shelf()

	var next_pos = nav_agent.get_next_path_position()
	var direction = (next_pos - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func _on_reached_shelf(shelf: Shelf):
	fill_basket_from_shelf(shelf.get_item_id(), shelf.pick_random_qty())

func go_to_checkout():
	# Placeholder
	print("Customer going to checkout with basket: ", basket)
	queue_free()
