extends StateMachine
class_name PlayerStateMachine


@export var eat_timer: Timer
@export var hurt_timer: Timer
var player: Player

func _ready():
	await owner.ready
	player = owner as Player
	assert(player != null, "PlayerStateMachine needs to be owned by Player node")
	super._ready()

func _process(delta):
	_handle_basic_movement()
	super._process(delta)

func start_hurt_timer():
	hurt_timer.start()

func start_eat_timer():
	eat_timer.start()

func _handle_basic_movement():
	var player_state := current_state as PlayerState
	if player_state == null or player_state.movement_allowed():
		var movement = Input.get_axis("move_left", "move_right")
		player.velocity.x = movement * player.movement_speed

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
