extends CharacterBody2D

@onready var state_machine = $StateMachine
@onready var nav_agent: NavigationAgent2D = $NavigationAgent

@onready var sprite := $Sprite
@export var sprite_texture: Texture2D
@onready var notification_label: Label = $FloatingUI/NotificationLabel

var basket: Dictionary = {}
var products_wanted: Array[String] = []

# min and max products amounts are the range of numbers of product a customer
# will attempt to purchase
@export var min_products := 1
@export var max_products := ProductDatabase.get_product_count()

@export var speed := 50.0

# the product the customer currently is looking for
var current_product: Product = null

# the shelf the customer currently wants to interact with
var target_shelf: Shelf = null

# the checkout counter at which the customer will check out
var checkout: Checkout = null

func _ready():
	products_wanted = get_wanted_products()
	print("customer products wanted: ", products_wanted)
	sprite.texture = sprite_texture
	
	# TODO remove after debugging
	print("Navigation map:", nav_agent.get_navigation_map())
	
	state_machine.init(self, nav_agent)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

# get_wanted_products returns a random number of available product ids
func get_wanted_products() -> Array[String]:
	var available_product_ids: Array[String] = ProductDatabase.get_product_ids()
	available_product_ids.shuffle()
	return available_product_ids.slice(0, randi_range(min_products, max_products))

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
