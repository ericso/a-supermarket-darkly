extends State

@export var wandering: State
@export var leaving: State

func enter() -> void:
	super()
	
	if parent.checkout == null:
		_should_transition = true
		_next_state = wandering
		return

func process_frame(_delta: float) -> State:
	if _should_transition:
		return _next_state
	
	parent.checkout.checkout_basket(parent.basket)
	return leaving
