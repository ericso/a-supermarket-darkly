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
	try_pick_shelf()

func try_pick_shelf():
	var shelf := GroceryStore.get_random_stocked_shelf()
	if shelf:
		nav_agent.set_target_position(shelf.global_position)
	else:
		print("No stocked shelves yet. Retrying in 1s.")
		await get_tree().create_timer(1.0).timeout
		try_pick_shelf()

func _physics_process(delta):
	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return

	var next_pos = nav_agent.get_next_path_position()
	var direction = (next_pos - global_position).normalized()
	velocity = direction * speed
	print("DEBUG::_physics_process velocity ", velocity)
	move_and_slide()

func _on_reached_shelf():
	print("Customer reached shelf!")

func go_to_checkout():
	# Placeholder
	print("Customer going to checkout with basket: ", basket)
	queue_free()
