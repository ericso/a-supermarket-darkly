extends State

@export var wandering: State
@export var finding_product: State

# min and max purchase amounts are the range of units of product a customer
# will attempt to buy for each product
@export var min_purchase_amount := 1
@export var max_purchase_amount := 4

func enter() -> void:
	print("DEBUG::enter state InteractingWithShelf with target_shelf ", parent.target_shelf)
	super()
	
	if parent.target_shelf == null:
		_should_transition = true
		_next_state = wandering
		return
	
	parent.basket[parent.target_shelf.get_product()] = parent.target_shelf.pick_quantity(randi_range(min_purchase_amount, max_purchase_amount))
	parent.current_product = null
	parent.target_shelf = null
	
	# next state
	_should_transition = true
	_next_state = finding_product
	return

func process_frame(_delta: float) -> State:
	if _should_transition:
		return _next_state
	return
	
