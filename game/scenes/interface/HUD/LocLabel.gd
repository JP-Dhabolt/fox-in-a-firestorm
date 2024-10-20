extends Label

func _process(_delta):
	var x_pos: int = -99
	var y_pos: int = -99
	if GameManager.current_player != null and GameManager.current_terrain_generator != null:
		var tile_pos := GameManager.current_terrain_generator.ground_layer.local_to_map(GameManager.current_player.global_position)
		x_pos = tile_pos.x
		y_pos = tile_pos.y

	text = "Loc: " + str(x_pos) + ", " + str(y_pos)
