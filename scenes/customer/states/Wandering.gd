extends State

@export var finding_product: State
@export var wandering: State
@export var checking_out: State

var wander_timer: Timer = null
@export var wander_time: float = 3.0

var is_wandering: bool = true

func enter() -> void:
	print("DEBUG::wandering state enter")
	super()
	
	# set up wandering time
	wander_timer = Timer.new()
	wander_timer.wait_time = wander_time
	wander_timer.one_shot = true
	add_child(wander_timer)
	wander_timer.timeout.connect(on_wander_timeout)
	
	# set wandering destination
	set_target_position(get_random_navigable_point())

func process_frame(delta: float) -> State:
	move_towards_target()
	if is_wandering:
		return
	return finding_product

func on_wander_timeout():
	is_wandering = false

# get_random_navigable_point returns a point in the grocery store
func get_random_navigable_point() -> Vector2:
	# some reasonable area of the grocery store
	var bounds := Rect2(Vector2(0, 0), Vector2(540, 600))
	return Vector2(
		randf_range(bounds.position.x, bounds.end.x),
		randf_range(bounds.position.y, bounds.end.y)
	)
