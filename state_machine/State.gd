class_name State extends Node

@export var animation_name: String

@export var move_speed: float = 100

# reference to the parent so that it can be controlled by the state
var parent: CharacterBody2D

var nav_agent: NavigationAgent2D = null

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	return null

func set_target_position(pos: Vector2) -> void:
	# defer calls to next frame
	await get_tree().process_frame
	
	var map = nav_agent.get_navigation_map()
	var safe_pos = NavigationServer2D.map_get_closest_point(map, pos)
	nav_agent.set_target_position(safe_pos)
	await nav_agent.path_changed

func move_towards_target() -> void:
	if nav_agent.is_navigation_finished():
		parent.velocity = Vector2.ZERO
	else:
		var next_pos = nav_agent.get_next_path_position()
		var direction = (next_pos - parent.global_position).normalized()
		parent.velocity = direction * parent.speed
	parent.move_and_slide()

func wait_at_location(time: float):
	await get_tree().create_timer(time).timeout
