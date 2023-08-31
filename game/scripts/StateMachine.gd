extends Node
class_name StateMachine

@export var initial_state: State
var states: Dictionary = {}
var current_state: State
var previous_state: State

func _ready():
	current_state = initial_state
	current_state.enter(null)

func _process(delta):
	current_state.update(delta)

func _physics_process(delta):
	current_state.update_physics(delta)

func register_state(state: State):
	states[state.name] = state


func transition_to(state_name: String):
	if current_state:
		current_state.exit()

	previous_state = current_state

	current_state = states[state_name]
	current_state.enter(previous_state)
