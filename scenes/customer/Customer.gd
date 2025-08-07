extends CharacterBody2D

@onready var state_machine = $StateMachine
@onready var nav_agent: NavigationAgent2D = $NavigationAgent

@onready var sprite := $Sprite
@export var sprite_texture: Texture2D
@onready var notification_label: Label = $FloatingUI/NotificationLabel

var basket: Dictionary = {}
var products_wanted: Array[String] = []

var notification_tween: Tween = null # tween used to fade out floating notifcation

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
	NotificationManager.add_log_message("new customer wants: %s" % str(products_wanted))
	
	sprite.texture = sprite_texture
	
	nav_agent.avoidance_enabled = true
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
func add_floating_notification(message: String, duration: float = 3.0):
	# Cancel any existing tween
	if notification_tween and notification_tween.is_valid():
		notification_tween.kill()

	# Reset opacity and set new message
	notification_label.modulate.a = 1.0
	notification_label.text = message

	# Create and store new tween
	notification_tween = notification_label.create_tween()
	notification_tween.tween_interval(duration)
	notification_tween.tween_property(notification_label, "modulate:a", 0.0, 0.5)

	notification_tween.finished.connect(func():
		if is_instance_valid(notification_label):
			notification_label.text = ""
	)
