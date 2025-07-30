extends State

var front_door: Door = null

func enter() -> void:
	super()
	front_door = StoreManager.get_front_door()
	set_target_position(front_door.global_position)
	await nav_agent.target_reached

func process_frame(_delta: float) -> State:
	move_towards_target()
	parent.queue_free()
	return
