extends PlayerState

var pounceAnimation: String = "Pounce"

func enter(_previous_state):
	state_machine.player.sprite.play(pounceAnimation)
	state_machine.player.velocity.y += state_machine.player.pounce_force

func update(_delta):
	if state_machine.player.is_on_floor():
		state_machine.transition_to("Hurting")

func on_collision(node: Node2D):
	var leaves := node as Leaves
	if leaves != null:
		state_machine.transition_to("Eating")
