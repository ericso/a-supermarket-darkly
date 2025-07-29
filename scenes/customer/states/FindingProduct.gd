extends State

@export var wandering: State
@export var walking_to_shelf: State
@export var walking_to_checkout: State

var _should_transition: bool = false
var _next_state: State = null

func enter() -> void:
	super()
	
	if current_product == null:
		if parent.products_wanted.is_empty():
			# no products to purchase
			_should_transition = true
			_next_state = walking_to_checkout
		else:
			current_product = parent.products_wanted.pop_front()
			_should_transition = true
			_next_state = walking_to_shelf

func process_frame(delta: float) -> State:
	if _should_transition:
		return _next_state
	return
