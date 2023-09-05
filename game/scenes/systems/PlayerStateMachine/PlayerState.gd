extends State
class_name PlayerState

var state_machine: PlayerStateMachine:
	set(p_state_machine):
		state_machine = p_state_machine
var state_name: String = "OverrideInSubclass": get = _get_state_name

func _get_state_name() -> String:
	return state_name

func on_collision(node: Node2D) -> void:
	var bush := node as Bush
	if bush != null:
		state_machine.register_impact()

func on_timeout(_timer: Timer) -> void:
	pass

func movement_allowed() -> bool:
	return true
