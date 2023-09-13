extends PlayerState

@export var water_impact_force: float = 75.0
@export var bouyancy: float = 10.0
@export var water_jump_force: float = 100.0


func _get_state_name() -> String:
	return "Swimming"

func enter(_previous_state):
	state_machine.player.velocity.y -= water_impact_force

func _get_gravity_modifier() -> float:
	return -bouyancy

func update(_delta) -> void:
	if Input.is_action_just_pressed("jump"):
		state_machine.player.velocity.y = -state_machine.underwater_jump_force
