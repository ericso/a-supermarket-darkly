extends State

@export var wandering: State
@export var walking_to_shelf: State
@export var walking_to_checkout: State

var _should_transition: bool = false
var _next_state: State = null

func enter() -> void:
	print("DEBUG::entering FindingProduct state")
	super()
	
	if parent.current_product == null:
		print("DEBUG::current_product ", parent.current_product)
		print("DEBUG::products_wanted ", parent.products_wanted)
		
		if parent.products_wanted.is_empty():
			# no products to purchase
			_should_transition = true
			_next_state = walking_to_checkout
		else:
			var product_id = parent.products_wanted.pop_front()
			
			print("DEBUG::finding product product_id ", product_id)
			
			parent.current_product = ProductDatabase.get_product(product_id)
			_should_transition = true
			_next_state = walking_to_shelf

func process_frame(_delta: float) -> State:
	if _should_transition:
		return _next_state
	return
