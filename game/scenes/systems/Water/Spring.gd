extends Object
class_name Spring


# Hooke's Law is F = -k * x where F is the force, k is the spring constant, and x is the displacement of the spring from its rest position.
# Loss = -d * v where d is the damping constant and v is the velocity of the spring.

var velocity: float = 0
var spring_constant: float
var damping_constant: float
var height: float

func _init(h: float, k: float = 0.015, d: float = 0.03) -> void:
	self.height = h
	self.spring_constant = k
	self.damping_constant = d

func determine_new_y(y_pos: float, target_height: float) -> float:
	height = y_pos
	var displacement := height - target_height
	var loss := -damping_constant * velocity
	var force := -spring_constant * displacement + loss
	velocity += force
	return y_pos + velocity
