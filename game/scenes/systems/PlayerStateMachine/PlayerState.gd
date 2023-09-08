extends State
class_name PlayerState

var state_machine: PlayerStateMachine:
	set(p_state_machine):
		state_machine = p_state_machine
var state_name: String = "OverrideInSubclass": get = _get_state_name
var gravity_modifier: float = 0.0: get = _get_gravity_modifier

func _get_state_name() -> String:
	return state_name

func _get_gravity_modifier() -> float:
	return gravity_modifier

func on_collision(node: Node2D) -> void:
	if node.has_method("determine_slowdown"):
		var slowdown = node.determine_slowdown()
		state_machine.change_player_speed(slowdown.multiplier, slowdown.time)

func on_timeout(_timer: Timer) -> void:
	pass

func movement_allowed() -> bool:
	return true
