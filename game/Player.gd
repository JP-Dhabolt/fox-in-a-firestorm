extends KinematicBody2D
class_name Player

var GRAVITY: int = 15
var MOVEMENT_SPEED: int = 150
var JUMP_FORCE: int = 200
var POUNCE_FORCE: int = 50

var jumpAnimation: String = "Jump"
var runAnimation: String = "Run"
var idleAnimation: String = "Idle"
var crouchAnimation: String = "Crouch"
var hurtAnimation: String = "Hurt"
var pounceAnimation: String = "Pounce"

enum State {
    NORMAL,
    JUMPING,
    POUNCING,
    CROUCHING,
    HURTING,
}

var velocity: Vector2 = Vector2.ZERO
var currentState = State.NORMAL

onready var sprite := $AnimatedSprite as AnimatedSprite
onready var hurtTimer := $HurtTimer as Timer
onready var eatTimer := $EatTimer as Timer


func eat():
	if currentState == State.POUNCING:
		_transition_to_crouching()


func _physics_process(_delta):
	velocity.y += GRAVITY
	_handle_shared_input()
	_handle_state()
	velocity = move_and_slide(velocity, Vector2.UP)


func _handle_state():
	match currentState:
		State.NORMAL:
			_handle_normal_state()
		State.JUMPING:
			_handle_jumping_state()
		State.POUNCING:
			_handle_pouncing_state()
		State.CROUCHING:
			_handle_crouching_state()
		State.HURTING:
			_handle_hurting_state()


func _transition_to_normal():
	currentState = State.NORMAL


func _handle_shared_input():
	if Input.is_action_pressed("ui_right"):
		velocity.x = MOVEMENT_SPEED
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -MOVEMENT_SPEED
	else:
		velocity.x = 0


func _handle_normal_state():
	if velocity.x != 0:
		sprite.play(runAnimation)
	else:
		sprite.play(idleAnimation)

	if Input.is_action_just_pressed("ui_up"):
		_transition_to_jumping()


func _transition_to_jumping():
	currentState = State.JUMPING
	velocity.y = -JUMP_FORCE
	sprite.play(jumpAnimation)


func _handle_jumping_state():
	if is_on_floor():
		_transition_to_normal()
	if Input.is_action_just_pressed("ui_up"):
		_transition_to_pouncing()


func _transition_to_pouncing():
	sprite.play(pounceAnimation)
	velocity.y += POUNCE_FORCE
	currentState = State.POUNCING


func _handle_pouncing_state():
	if is_on_floor():
		# If we're on the floor, we haven't hit leaves, so we're stunned
		_transition_to_hurting()


func _transition_to_crouching():
	currentState = State.CROUCHING
	sprite.play(crouchAnimation)
	eatTimer.start()


func _handle_crouching_state():
	pass


func _transition_to_hurting():
	currentState = State.HURTING
	sprite.play(hurtAnimation)
	hurtTimer.start()


func _handle_hurting_state():
	pass


func _on_HurtTimer_timeout():
	_transition_to_normal()


func _on_EatTimer_timeout():
	_transition_to_normal()
