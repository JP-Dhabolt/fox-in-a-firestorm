extends CharacterBody2D
class_name Player

@export var food: int = 75
@export var food_tick_rate: int = 2

@onready var sprite := $AnimatedSprite2D as AnimatedSprite2D
@onready var state_machine := $PlayerStateMachine as PlayerStateMachine

var elapsed_time: float = 0

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
