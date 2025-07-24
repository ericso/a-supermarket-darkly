extends CharacterBody2D

@export var speed := 300.0
@export var min_items := 1
@export var max_items := ItemDatabase.get_item_count()

@onready var sprite := $Sprite

@export var sprite_texture: Texture2D
@onready var nav_agent := $NavigationAgent

var basket: Dictionary = {}
var num_items_to_buy: int = 0
var visited_shelves: Dictionary = {}

func _ready():
	num_items_to_buy = RandomNumberGenerator.new().randi_range(min_items, max_items)
	sprite.texture = sprite_texture
	visit_random_stocked_shelf()

func _physics_process(_delta):
	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		
		if num_items_to_buy > 0:
			while !visit_random_stocked_shelf():
				await get_tree().create_timer(1.0).timeout # wait 1 sec and try again
		else:
			go_to_checkout()
	else:
		var next_pos = nav_agent.get_next_path_position()
		var direction = (next_pos - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

func move_to_position(pos: Vector2) -> void:
	var map = nav_agent.get_navigation_map()
	var safe_pos = NavigationServer2D.map_get_closest_point(map, pos)
	nav_agent.set_target_position(safe_pos)

# visit_random_stocked_shelf will pick a randomly stocked shelf, and navigate
# the customer to that shelf. If there is a navigable stocked shelf, returns true.
# If there are no stocked shelves, return false.
func visit_random_stocked_shelf() -> bool:
	var shelf: Shelf = GroceryStore.get_random_stocked_shelf()
	if shelf and !visited_shelves.has(shelf.get_item().id):
		move_to_position(shelf.global_position)
		
		# disconnect any previous connection made before connecting to new shelf
		if nav_agent.is_connected("target_reached", Callable(self, "on_reached_shelf")):
			nav_agent.target_reached.disconnect(Callable(self, "on_reached_shelf"))
		nav_agent.target_reached.connect(func(): on_reached_shelf(shelf), CONNECT_ONE_SHOT)
		visited_shelves[shelf.get_item().id] = null
		return true
	return false

func on_reached_shelf(shelf: Shelf):
	fill_basket_from_shelf(shelf.get_item(), shelf.pick_random_qty())
	num_items_to_buy -= 1

func fill_basket_from_shelf(item: Item, qty: int):
	basket[item] = qty

func go_to_checkout():
	var checkout: Checkout = GroceryStore.get_open_checkout()
	move_to_position(checkout.global_position)
	nav_agent.target_reached.connect(func(): on_reached_checkout(checkout), CONNECT_ONE_SHOT)

func on_reached_checkout(checkout: Checkout):
	for _item in basket:
		checkout.checkout_item(_item, basket[_item])
	
	# TODO the customer should walk to the door, leave and then call queue_free()
	queue_free()
	
	# TODO remove after testing
	print(GroceryStore.items_sold)
