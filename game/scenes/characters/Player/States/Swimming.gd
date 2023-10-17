extends PlayerState

@export var water_impact_force: float = 75.0
@export var bouyancy: float = 10.0
@export var water_jump_force: float = 100.0
@export var water_speed_multiplier: float = 0.33
@export var heat_reduction_amount: float = 5
@export var heat_reduction_rate: float = 0.01

var crouch_animation = "Crouch"

func _get_state_name() -> String:
	return "Swimming"

func enter(_previous_state):
	state_machine.player.sprite.play(crouch_animation)
	state_machine.player.velocity.y -= water_impact_force
	state_machine.player.heat -= heat_reduction_amount

func _get_gravity_modifier() -> float:
	return -bouyancy

func update_physics(_delta) -> void:
	state_machine.change_player_speed(water_speed_multiplier, 0.0)
	state_machine.player.heat -= heat_reduction_rate
	if Input.is_action_just_pressed("jump"):
		state_machine.player.velocity.y = -state_machine.underwater_jump_force
