extends PlayerState

var run_animation: String = "Run"
var idle_animation: String = "Idle"
var jump_state: String = "Jump"

func _get_state_name() -> String:
	return "Normal"

func update(_delta) -> void:
	if state_machine.player.velocity.x != 0:
		state_machine.player.sprite.play(run_animation)
	else:
		state_machine.player.sprite.play(idle_animation)

	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to(state_machine.states.jumping)
