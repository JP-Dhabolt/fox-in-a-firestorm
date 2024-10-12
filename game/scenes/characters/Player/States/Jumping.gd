extends PlayerState

var jump_animation: String = "Jump"

func _get_state_name() -> String:
	return "Jumping"

func enter(_previous_state: State) -> void:
	state_machine.player.velocity.y = -state_machine.jump_force
	state_machine.player.sprite.play(jump_animation)

func update_physics(_delta):
	var player = state_machine.player
	if player.velocity.y >= 0 and player.is_on_floor():
		state_machine.transition_to(state_machine.states.normal)
	if Input.is_action_just_pressed("pounce"):
		state_machine.transition_to(state_machine.states.pouncing)
