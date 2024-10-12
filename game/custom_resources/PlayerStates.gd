extends Node
class_name PlayerStates

@export var normal: PlayerState
@export var jumping: PlayerState
@export var pouncing: PlayerState
@export var eating: PlayerState
@export var hurting: PlayerState
@export var swimming: PlayerState

func register_all(state_machine: PlayerStateMachine):
	var _states: Array[PlayerState] = [
		normal,
		jumping,
		pouncing,
		eating,
		hurting,
		swimming
	]
	for state in _states:
		state.state_machine = state_machine
