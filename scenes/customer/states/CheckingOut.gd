extends State

@export var wandering: State
@export var leaving: State

var _should_transition: bool = false
var _next_state: State = null

@export var checkout_wait_time: float = 4.0

func enter() -> void:
	super()
	
	if checkout == null:
		_should_transition = true
		_next_state = wandering
		return

func process_frame(delta: float) -> State:
	if _should_transition:
		return _next_state
	
	await wait_at_location(checkout_wait_time)
	checkout.checkout_basket(parent.basket)
	return leaving
