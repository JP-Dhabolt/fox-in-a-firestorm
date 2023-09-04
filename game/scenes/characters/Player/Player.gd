extends CharacterBody2D
class_name Player

signal collided_with(node: Node2D)

@export var gravity: int = 15
@export var movement_speed: float = 150.0
@export var jump_force: int = 200
@export var pounce_force: int = 50
@export var food: int = 75
@export var food_tick_rate: int = 2

@onready var sprite := $AnimatedSprite2D as AnimatedSprite2D

var elapsed_time: float = 0

func _physics_process(_delta):
	velocity.y += gravity
	set_velocity(velocity)
	set_up_direction(Vector2.UP)
	move_and_slide()
	velocity = velocity

func _process(delta: float):
	elapsed_time += delta

	if elapsed_time >= 1.0 / food_tick_rate:
		elapsed_time -= 1.0 / food_tick_rate
		food -= 1

func on_collision(node: Node2D):
	emit_signal("collided_with", node)

func eat(amount: int):
	food = min(100, food + amount)
