extends Area2D
class_name Bush

func _on_body_entered(body:Node2D):
	var player := body as Player
	if player != null:
		player.on_collision(self)
