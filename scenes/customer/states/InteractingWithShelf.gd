extends State

@export var wandering: State
@export var finding_product: State

var _should_transition: bool = false
var _next_state: State = null

@export var shelf_wait_time: float = 2.0

# min and max purchase amounts are the range of units of product a customer
# will attempt to buy for each product
@export var min_purchase_amount := 1
@export var max_purchase_amount := 4

func enter() -> void:
	super()
	
	if parent.target_shelf == null:
		_should_transition = true
		_next_state = wandering
		return

func process_frame(delta: float) -> State:
	if _should_transition:
		return _next_state
	
	await wait_at_location(shelf_wait_time)
	parent.basket[parent.target_shelf.get_product()] = parent.target_shelf.pick_quantity(randi_range(min_purchase_amount, max_purchase_amount))
	parent.current_product = null
	parent.target_shelf = null
	return finding_product
