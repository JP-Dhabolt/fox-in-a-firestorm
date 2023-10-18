extends PlayerState

var hurt_animation: String = "Hurt"

func _get_state_name() -> String:
	return "Hurting"

func enter(_previous_state):
	state_machine.player.velocity = Vector2.ZERO
	state_machine.player.sprite.play(hurt_animation)
	state_machine.start_hurt_timer()

func on_timeout(timer: Timer):
	if timer.name == "HurtTimer":
		state_machine.transition_to(state_machine.states.normal)

func movement_allowed():
	return false

func on_collision(node: Node2D):
	# If we've collided with an edible node while hurting, it was because
	# we processed the ground hit first. Player should be allowed to eat.
	if IEdible.implements(node):
		if node.eat_me():
			state_machine.transition_to(state_machine.states.eating)
	super.on_collision(node)
