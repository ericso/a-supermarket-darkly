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
	pick_random_shelf_and_go()

func _physics_process(delta):
	if nav_agent.is_navigation_finished():
		return

	var next_path_position = nav_agent.get_next_path_position()
	var direction = (next_path_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

func pick_random_shelf_and_go():
	var shelf: Node2D = GroceryStore.get_random_stocked_shelf()
	if shelf:
		nav_agent.set_target_position(shelf.global_position)
	else:
		print("DEBUG::pick_random_shelf_and_go no stocked shelves")
		# TODO implement some sort of idle state
		
func _on_reached_shelf():
	print("Customer reached shelf!")

func go_to_checkout():
	# Placeholder
	print("Customer going to checkout with basket: ", basket)
	queue_free()
