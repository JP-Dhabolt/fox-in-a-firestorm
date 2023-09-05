extends Node
class_name PlayerStateMachine


@export_group("Setup")
@export var player: Player
@export var states: PlayerStates

@export_group("Timers")
@export var eat_timer: Timer
@export var hurt_timer: Timer

@export_group("Physics")
@export var impact_slowdown_amount: float = 0.9
@export var impact_slowdown_time: float = 6.0

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
	player.movement_speed = player.movement_speed * multiplier
	_player_speed_changes.append(PlayerSpeedChange.new(multiplier, duration + _elapsed_time))

func register_impact():
	change_player_speed(impact_slowdown_amount, impact_slowdown_time)

func _handle_basic_movement():
	_handle_speed_updates()
	var player_state := current_state as PlayerState
	if player_state == null or player_state.movement_allowed():
		var movement = Input.get_axis("move_left", "move_right")
		player.velocity.x = movement * player.movement_speed

func _handle_speed_updates():
	var items_to_remove: Array[PlayerSpeedChange] = []
	for speed_change in _player_speed_changes:
		if _elapsed_time > speed_change.expiration:
			items_to_remove.append(speed_change)

	for item in items_to_remove:
		player.movement_speed = player.movement_speed / item.speed_multiplier
		_player_speed_changes.erase(item)

func _on_player_collided_with(node: Node2D):
	var player_state := current_state as PlayerState
	if player_state != null:
		player_state.on_collision(node)

func _on_hurt_timer_timeout():
	var player_state := current_state as PlayerState
	if player_state != null:
		player_state.on_timeout(hurt_timer)

func _on_eat_timer_timeout():
	var player_state := current_state as PlayerState
	if player_state != null:
		player_state.on_timeout(eat_timer)
