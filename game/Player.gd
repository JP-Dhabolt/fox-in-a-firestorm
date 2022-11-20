extends KinematicBody2D

var GRAVITY: int = 15
var MOVEMENT_SPEED: int = 150
var JUMP_FORCE: int = 200

var jumpAnimation: String = "Jump"
var runAnimation: String = "Run"
var idleAnimation: String = "Idle"

var velocity: Vector2 = Vector2.ZERO

onready var sprite := $AnimatedSprite as AnimatedSprite


func _physics_process(_delta):
	velocity.y += GRAVITY
	_handle_inputs()
	velocity = move_and_slide(velocity, Vector2.UP)
	_animate()


func _handle_inputs():
	if Input.is_action_pressed("ui_right"):
		velocity.x = MOVEMENT_SPEED
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -MOVEMENT_SPEED
	else:
		velocity.x = 0

	if Input.is_action_just_pressed("ui_up"):
		velocity.y = -JUMP_FORCE


func _animate():
	if is_on_floor():
		if velocity.x != 0:
			sprite.play(runAnimation)
		else:
			sprite.play(idleAnimation)
	else:
		sprite.play(jumpAnimation)
