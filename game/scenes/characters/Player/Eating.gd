extends PlayerState

var crouch_animation = "Crouch"
var original_movement_speed: int
@export var player_speed_multiplier = 0.5
@export var food_amount = 10

func enter(_previous_state):
	state_machine.player.sprite.play(crouch_animation)
	state_machine.start_eat_timer()
	original_movement_speed = state_machine.player.movement_speed
	state_machine.player.movement_speed = int(state_machine.player.movement_speed * player_speed_multiplier)
	state_machine.player.eat(food_amount)

func exit():
	state_machine.player.movement_speed = original_movement_speed

func on_timeout(timer: Timer):
	if timer.name == "EatTimer":
		state_machine.transition_to("Normal")
