extends State

@export var checking_out: State

func enter() -> void:
	print("DEBUG::entering WalkingToCheckout state")
	super()
	parent.checkout = StoreManager.get_open_checkout()
	if parent.checkout == null:
		push_error("checkout should not be null")
	set_target_position(parent.checkout.global_position)

func process_frame(delta: float) -> State:
	move_towards_target()
	await nav_agent.target_reached
	return checking_out
