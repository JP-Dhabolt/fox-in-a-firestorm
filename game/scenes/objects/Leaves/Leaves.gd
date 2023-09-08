extends Area2D
class_name Leaves


@onready var sprite = $AnimatedSprite2D
@export var rodent_chance: float = 0.85

var has_rodent = true

func _ready():
	if randf() > rodent_chance:
		has_rodent = false
		sprite.play("empty")
	else:
		sprite.play("full")

func eat_me():
	if has_rodent:
		has_rodent = false
		sprite.play("empty")
		return true

	return false
