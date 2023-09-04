extends State
class_name PlayerState

var state_machine: PlayerStateMachine

func _ready():
	state_machine = get_parent() as PlayerStateMachine
	assert(state_machine != null, "PlayerState needs to be a child of PlayerStateMachine")
	state_machine.register_state(self)

func on_collision(node: Node2D) -> void:
	var bush := node as Bush
	if bush != null:
		state_machine.register_impact()

func on_timeout(_timer: Timer) -> void:
	pass

func movement_allowed() -> bool:
	return true
