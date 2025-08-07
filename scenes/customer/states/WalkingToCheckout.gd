extends State

@export var checking_out: State
@export var wandering: State

func enter() -> void:
	super()
	
	parent.add_floating_notification("done shopping, going to check out!")
	
	parent.checkout = StoreManager.get_open_checkout()
	if parent.checkout != null:
		set_target_position(parent.checkout.global_position)
	else:
		parent.add_floating_notification("no checkouts available! :(")
		_should_transition = true
		_next_state = wandering

func process_frame(_delta: float) -> State:
	if _should_transition:
		return _next_state
		
	move_towards_target()
	await nav_agent.target_reached
	return checking_out
