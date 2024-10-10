extends Label

var tilemap: TileMap
var player: Player

func _ready():
	await owner.ready
	player = owner.player as Player
	assert(player != null, "Player must be available to use this node")
	await owner.terrain_generator.ready
	tilemap = owner.terrain_generator.tilemap as TileMap
	assert(tilemap != null, "TerrainGenerator TileMape must be available to use this node")

func _process(_delta):
	var tile_pos := tilemap.local_to_map(player.global_position)
	text = "Loc: " + str(tile_pos.x) + ", " + str(tile_pos.y)
