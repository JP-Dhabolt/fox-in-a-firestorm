extends Area2D
class_name Bush

@export var slowdown_multiplier: float = 0.9
@export var slowdown_time: float = 6.0

func determine_slowdown():
	return {
		"multiplier": slowdown_multiplier,
		"time": slowdown_time,
	}
