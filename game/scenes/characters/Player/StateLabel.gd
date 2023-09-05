extends Label


@export var state_machine: PlayerStateMachine

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	text = state_machine.current_state.state_name
