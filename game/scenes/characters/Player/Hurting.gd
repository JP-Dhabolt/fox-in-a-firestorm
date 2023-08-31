extends PlayerState

var hurt_animation: String = "Hurt"

func enter(_previous_state):
	state_machine.player.velocity = Vector2.ZERO
	state_machine.player.sprite.play(hurt_animation)
	state_machine.start_hurt_timer()

func on_timeout(timer: Timer):
	if timer.name == "HurtTimer":
		state_machine.transition_to("Normal")

func movement_allowed():
	return false
