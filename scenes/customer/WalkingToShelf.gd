extends State

@export var wandering: State
@export var interacting_with_shelf: State

var _should_transition: bool = false
var _next_state: State = null

func enter() -> void:
	print("DEBUG::enter state WalkingToShelf with current_product ", parent.current_product)
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
	set_target_position(parent.target_shelf.global_position)
	await nav_agent.target_reached
	_should_transition = true
	_next_state = interacting_with_shelf

func process_frame(delta: float) -> State:
	if _should_transition:
		return _next_state
	
	move_towards_target()
	return
