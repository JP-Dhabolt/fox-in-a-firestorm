extends PlayerState

var jump_animation: String = "Jump"

func enter(_previous_state: State) -> void:
	state_machine.player.velocity.y = -state_machine.player.jump_force
	state_machine.player.sprite.play(jump_animation)

func update(_delta):
	var player = state_machine.player
	if player.velocity.y >= 0 and player.is_on_floor():
		state_machine.transition_to("Normal")
	if Input.is_action_just_pressed("jump"):
		state_machine.transition_to("Pouncing")
