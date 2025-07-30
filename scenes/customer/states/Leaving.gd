extends State

var front_door: Door = null

func enter() -> void:
	super()
	front_door = StoreManager.get_front_door()
	await set_target_position(front_door.global_position)

func process_frame(_delta: float) -> State:
	if nav_agent.is_navigation_finished():
		parent.queue_free()
		return null
	
	move_towards_target()
	
	return null
