extends Resource
class_name PlayerStates

var normal: PlayerState:
	set(p_normal):
		normal = p_normal

var jumping: PlayerState:
	set(p_jumping):
		jumping = p_jumping

var pouncing: PlayerState:
	set(p_pouncing):
		pouncing = p_pouncing

var eating: PlayerState:
	set(p_eating):
		eating = p_eating

var hurting: PlayerState:
	set(p_hurting):
		hurting = p_hurting

var swimming: PlayerState:
	set(p_swimming):
		swimming = p_swimming

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
