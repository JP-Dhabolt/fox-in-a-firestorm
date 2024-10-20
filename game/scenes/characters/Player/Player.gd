extends CharacterBody2D
class_name Player

@export var food: int = 75
@export var food_tick_rate: int = 2
@export var heat: float = 50:
	get:
		return heat
	set(p_heat):
		heat = max(0, p_heat)

@onready var sprite := $AnimatedSprite2D as AnimatedSprite2D
@onready var state_machine := $PlayerStateMachine as PlayerStateMachine

var elapsed_time: float = 0
var sprite_x_pos_right: float = 10.5
var sprite_x_pos_left: float = 9.5

func _process(delta: float):
	elapsed_time += delta

	if elapsed_time >= 1.0 / food_tick_rate:
		elapsed_time -= 1.0 / food_tick_rate
		food -= 1

func eat(amount: int):
	food = min(100, food + amount)


func _on_terrain_generator_entered_water(body: Node2D):
	if body is Player:
		state_machine.transition_to(state_machine.states.swimming)

func _on_terrain_generator_exited_water(body: Node2D):
	if body is Player:
		state_machine.transition_to(state_machine.states.jumping)

func face_left():
	sprite.flip_h = true
	sprite.position.x = sprite_x_pos_left

func face_right():
	sprite.flip_h = false
	sprite.position.x = sprite_x_pos_right
