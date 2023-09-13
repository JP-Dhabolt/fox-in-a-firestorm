extends Area2D

signal entered_water
signal left_water

const WATER_COLLISION_LAYER: int = 0
var is_in_water: bool = false
var water_collider_count: int = 0

func _on_body_entered(body: Node2D):
	print("Body Entered with collider count of ", water_collider_count)
	var tilemap := body as TileMap
	if tilemap != null:
		var tilemap_loc := tilemap.local_to_map(global_position)
		print("In TileMap Location ", tilemap_loc)
		var tile_data := tilemap.get_cell_tile_data(WATER_COLLISION_LAYER, tilemap_loc)
		if tile_data:
			# We're in the water
			water_collider_count += 1
			if is_in_water:
				# We were already in the water, so don't emit the signal
				return

			is_in_water = true
			emit_signal("entered_water")


func _on_body_exited(body: Node2D):
	print("Body Exited with collider count of ", water_collider_count)
	var tilemap := body as TileMap
	if tilemap != null:
		var tilemap_loc := tilemap.local_to_map(global_position)
		var tile_data := tilemap.get_cell_tile_data(WATER_COLLISION_LAYER, tilemap_loc)
		if tile_data:
			# We're in the water
			water_collider_count -= 1
			if water_collider_count > 0:
				# We're still in the water, so don't emit the signal
				return

			is_in_water = false
			emit_signal("left_water")
