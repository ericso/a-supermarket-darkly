extends CharacterBody2D

@export var speed := 100.0

@onready var sprite := $Sprite

@export var sprite_texture: Texture2D
@onready var nav_agent := $NavigationAgent

# TODO implement usage of basket
var basket: Array[String] = []  # item IDs

func _ready():
	sprite.texture = sprite_texture
	nav_agent.target_reached.connect(_on_reached_shelf)
	visit_random_stocked_shelf()

# visit_random_stocked_shelf will pick a randomly stocked shelf, and navigate
# the customer to that shelf. If there are no stocked shelves, the customer will
# remain motionless and try again in 1 second.
func visit_random_stocked_shelf():
	var shelf := GroceryStore.get_random_stocked_shelf()
	if shelf:
		var map = nav_agent.get_navigation_map()
		var target_pos = shelf.global_position
		var safe_pos = NavigationServer2D.map_get_closest_point(map, target_pos)
		nav_agent.set_target_position(safe_pos)
	else:
		await get_tree().create_timer(1.0).timeout
		visit_random_stocked_shelf()

func fill_basket_from_shelf():
	# TODO how do we get the shelf reference here?
	print("DEBUG::fill_basket_from_shelf")

func _physics_process(_delta):
	if nav_agent.is_navigation_finished():
		#print("DEBUG::navigation is finished")
		velocity = Vector2.ZERO
		#visit_random_stocked_shelf()

	var next_pos = nav_agent.get_next_path_position()
	var direction = (next_pos - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func _on_reached_shelf():
	fill_basket_from_shelf()

func go_to_checkout():
	# Placeholder
	print("Customer going to checkout with basket: ", basket)
	queue_free()
