extends Area2D
class_name Leaves


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Leaves_body_entered(body: Node):
	var player := body as Player
	if player != null:
		player.on_collision(self)
