extends PlayerState

var crouch_animation = "Crouch"
@export var player_speed_multiplier = 0.5
@export var food_amount = 10

func enter(_previous_state):
	state_machine.player.sprite.play(crouch_animation)
	state_machine.start_eat_timer()
	state_machine.change_player_speed(player_speed_multiplier, state_machine.eat_timer.time_left)
	state_machine.player.eat(food_amount)

func on_timeout(timer: Timer):
	if timer.name == "EatTimer":
		state_machine.transition_to("Normal")
