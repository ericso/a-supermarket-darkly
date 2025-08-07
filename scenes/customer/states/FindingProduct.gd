extends State

@export var wandering: State
@export var walking_to_shelf: State
@export var walking_to_checkout: State

func enter() -> void:
	super()
	
	if parent.current_product == null:
		if parent.products_wanted.is_empty():
			# no products to purchase
			_should_transition = true
			_next_state = walking_to_checkout
		else:
			var product_id = parent.products_wanted.pop_front()
			parent.current_product = ProductDatabase.get_product(product_id)
			parent.add_floating_notification("getting %s" % parent.current_product.label)
			
			_should_transition = true
			_next_state = walking_to_shelf
	else:
		_should_transition = true
		_next_state = walking_to_shelf

func process_frame(_delta: float) -> State:
	if _should_transition:
		return _next_state
	return null
