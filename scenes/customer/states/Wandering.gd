extends State

@export var finding_product: State
@export var checking_out: State

func enter() -> void:
	print("DEBUG::wandering state enter")
	super()
	
	# set wandering destination
	await set_target_position(get_random_navigable_point())

func process_frame(_delta: float) -> State:
	if nav_agent.is_navigation_finished():
		return finding_product
	move_towards_target()
	return null

# get_random_navigable_point returns a point in the grocery store
func get_random_navigable_point() -> Vector2:
	# some reasonable area of the grocery store
	var bounds := Rect2(Vector2(0, 0), Vector2(540, 600))
	return Vector2(
		randf_range(bounds.position.x, bounds.end.x),
		randf_range(bounds.position.y, bounds.end.y)
	)
