extends Object
class_name PlayerSpeedChange

var speed_multiplier: float
var expiration: float

func _init(multiplier: float, expiration_time: float):
	self.speed_multiplier = multiplier 
	self.expiration = expiration_time
