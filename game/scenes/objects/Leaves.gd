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


func _on_Leaves_body_entered(body: Node):
	var player := body as Player
	if player != null && has_rodent:
		player.on_collision(self)

func eat_me():
	has_rodent = false
	sprite.play("empty")
