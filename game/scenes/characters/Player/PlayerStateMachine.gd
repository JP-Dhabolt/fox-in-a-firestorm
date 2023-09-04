extends StateMachine
class_name PlayerStateMachine


@export var eat_timer: Timer
@export var hurt_timer: Timer
@export var impact_slowdown_amount: float = 0.9
@export var impact_slowdown_time: float = 6.0

var player: Player
var _player_speed_changes: Array[PlayerSpeedChange] = []
var _elapsed_time: float = 0.0

func _ready():
	await owner.ready
	player = owner as Player
	assert(player != null, "PlayerStateMachine needs to be owned by Player node")
	super._ready()

func _process(delta):
	_elapsed_time += delta
	_handle_basic_movement()
	super._process(delta)

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
