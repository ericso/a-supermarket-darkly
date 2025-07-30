extends State

@export var wandering: State
@export var interacting_with_shelf: State

## WalkingToShelf state: the destination shelf is set in the enter() function
## by finding a stocked shelf with the parent.current_product

func enter() -> void:
	super()
	
	if parent.current_product == null:
		_should_transition = true
		_next_state = wandering
		return
	
	var shelves_for_product: Array[Shelf] = StoreManager.get_shelf_for_product_id(parent.current_product.id)
	if shelves_for_product.size() == 0:
		parent.add_floating_notification("can't find %s" % parent.current_product.label)
		_should_transition = true
		_next_state = wandering
		return
	
	# just take the first shelf
	parent.target_shelf = shelves_for_product[0]
	await set_target_position(parent.target_shelf.global_position)

func process_frame(_delta: float) -> State:
	if _should_transition:
		return _next_state
	
	if nav_agent.is_navigation_finished():
		return interacting_with_shelf
	
	move_towards_target()
	return null
