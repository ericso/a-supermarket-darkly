extends State

@export var wandering: State
@export var leaving: State

@export var checkout_wait_time: float = 4.0

func enter() -> void:
	super()
	
	if parent.checkout == null:
		_should_transition = true
		_next_state = wandering
		return

func process_frame(_delta: float) -> State:
	if _should_transition:
		return _next_state
	
	await wait_at_location(checkout_wait_time)
	parent.checkout.checkout_basket(parent.basket)
	return leaving
