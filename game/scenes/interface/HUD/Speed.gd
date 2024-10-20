extends Label

func _process(_delta):
	var speed: int = -99
	if GameManager.current_player != null:
		speed = int(GameManager.current_player.state_machine.movement_speed)

	text = "Speed: " + str(speed)
