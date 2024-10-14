extends Label

var label_text: String = "Heat: {0}"

func _process(_delta):
	var heat: int = -99

	if GameManager.current_player != null:
		heat = int(GameManager.current_player.heat)

	text = label_text.format([(heat)])
