extends Node
class_name PlayerStateMachine


@export_group("Setup")
@export var player: Player
@export var states: PlayerStates

@export_group("Timers")
@export var eat_timer: Timer
@export var hurt_timer: Timer

@export_group("Physics")
@export var gravity: float = 15.0
@export var movement_speed: float = 150.0
@export var jump_force: int = 300
@export var underwater_jump_force: int = 100
@export var pounce_force: int = 50

var current_state: PlayerState
var previous_state: PlayerState
var _player_speed_changes: Array[PlayerSpeedChange] = []
var _elapsed_time: float = 0.0

func _ready():
	states.register_all(self)
	current_state = states.normal
	current_state.enter(null)

func _process(delta):
	_elapsed_time += delta
	_handle_basic_movement()
	current_state.update(delta)

func _physics_process(delta):
	current_state.update_physics(delta)

func transition_to(state: PlayerState):
	if current_state:
		current_state.exit()

	previous_state = current_state

	current_state = state
	current_state.enter(previous_state)

func start_hurt_timer():
	hurt_timer.start()

func start_eat_timer():
	eat_timer.start()

func change_player_speed(multiplier: float, duration: float):
	movement_speed = movement_speed * multiplier
	_player_speed_changes.append(PlayerSpeedChange.new(multiplier, duration + _elapsed_time))

func _handle_basic_movement():
	_handle_speed_updates()
	player.velocity.y += gravity + current_state.gravity_modifier
	if current_state.movement_allowed():
		var movement = Input.get_axis("move_left", "move_right")
		player.velocity.x = movement * movement_speed
	player.move_and_slide()

func _handle_speed_updates():
	var items_to_remove: Array[PlayerSpeedChange] = []
	for speed_change in _player_speed_changes:
		if _elapsed_time > speed_change.expiration:
			items_to_remove.append(speed_change)

	for item in items_to_remove:
		movement_speed = movement_speed / item.speed_multiplier
		_player_speed_changes.erase(item)

func _on_hurt_timer_timeout():
	current_state.on_timeout(hurt_timer)

func _on_eat_timer_timeout():
	current_state.on_timeout(eat_timer)

func _on_collider_entered(body: Node2D):
	current_state.on_collision(body)
