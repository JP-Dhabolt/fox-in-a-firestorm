extends Label

var ground_layer: TileMapLayer
var player: Player

func _ready():
	await owner.ready
	player = owner.player as Player
	assert(player != null, "Player must be available to use this node")
	await owner.terrain_generator.ready
	ground_layer = owner.terrain_generator.ground_layer as TileMapLayer
	assert(ground_layer != null, "TerrainGenerator TileMape must be available to use this node")

func _process(_delta):
	var tile_pos := ground_layer.local_to_map(player.global_position)
	text = "Loc: " + str(tile_pos.x) + ", " + str(tile_pos.y)
