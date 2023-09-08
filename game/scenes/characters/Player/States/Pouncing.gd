extends PlayerState

var pounceAnimation: String = "Pounce"

func _get_state_name() -> String:
	return "Pouncing"

func enter(_previous_state):
	state_machine.player.sprite.play(pounceAnimation)
	state_machine.player.velocity.y += state_machine.pounce_force

func update(_delta):
	if state_machine.player.is_on_floor():
		state_machine.transition_to(state_machine.states.hurting)

func on_collision(node: Node2D):
	if node.has_method("eat_me"):
		if node.eat_me():
			state_machine.transition_to(state_machine.states.eating)
	super.on_collision(node)
