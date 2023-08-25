extends Node2D

@onready var tilemap := $TileMap as TileMap
@export var player_node: Node2D

var earliest_x_drawn: int = 0
var latest_x_drawn: int = 0
var elapsed_time = 0.0
var fast_noise: FastNoiseLite

var max_x: int
var min_x: int = 0
var max_y: int
var min_y: int

# Called when the node enters the scene tree for the first time.
func _ready():
	fast_noise = NoiseForTerrain.get_noise_by_type(NoiseForTerrain.NoiseForTerrainType.INITIAL)
	var viewport_rect = get_viewport_rect()
	max_x = ceil(viewport_rect.size.x / 16)
	max_y = ceil(viewport_rect.size.y / 16)
	min_y = ceil(max_y / 3.0)
	for x in range(min_x, max_x + 5):
		_place_tile(x)

	latest_x_drawn = max_x + 5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_node_x = tilemap.local_to_map(player_node.global_position).x
	if int(delta) % 5 == 0:
		print("Player location: ", player_node_x)
		print("Current tilemap count: ", len(tilemap.get_used_cells(0)))
	_draw_and_clear_map(player_node_x)

func _draw_and_clear_map(player_x: int):
	_draw_right_if_needed(player_x)
	_draw_left_if_needed(player_x)
	_clear_right_if_needed(player_x)
	_clear_left_if_needed(player_x)

func _draw_right_if_needed(player_x: int):
	if player_x + max_x > latest_x_drawn:
		print("Drawing to the  right")
		for x in range(latest_x_drawn, player_x + max_x):
			_place_tile(x)
		latest_x_drawn = player_x + max_x

func _draw_left_if_needed(player_x: int):
	if player_x - max_x < earliest_x_drawn:
		print("Drawing to the left")
		for x in range(max(0, player_x - max_x), earliest_x_drawn):
			_place_tile(x)
		earliest_x_drawn = max(0, player_x - max_x)

func _clear_right_if_needed(player_x: int):
	if player_x + max_x * 2 < latest_x_drawn:
		print("Clearing to the right")
		for x in range(player_x + max_x, latest_x_drawn):
			_erase_tile(x)
		latest_x_drawn = player_x + max_x

func _clear_left_if_needed(player_x: int):
	if player_x - max_x * 2 > earliest_x_drawn:
		print("Clearing to the left")
		for x in range(earliest_x_drawn, max(player_x - max_x, 0)):
			_erase_tile(x)
		earliest_x_drawn = max(player_x - max_x, 0)

func _place_tile(x: int):
	var y_val = _determine_y_value(x)
	var vectors = range(y_val, max_y).map(func(y): return Vector2i(x, y))
	tilemap.set_cells_terrain_connect(0, vectors, 0, 0)

func _erase_tile(x: int):
	for y in range(min_y, max_y):
		tilemap.erase_cell(0, Vector2i(x, y))

func _determine_y_value(x: int):
	var noise_value = fast_noise.get_noise_1d(x)
	var normalized_noise = (noise_value + 1) / 2
	var y_range = max_y - min_y
	return min_y + int(normalized_noise * y_range)

func redraw_terrain():
	tilemap.clear()
	fast_noise.seed = randi()
	for x in range(earliest_x_drawn, latest_x_drawn):
		_place_tile(x)

func randomize_terrain():
	fast_noise = NoiseForTerrain.get_noise_by_type(NoiseForTerrain.NoiseForTerrainType.RANDOM)
	print_object_properties(fast_noise)
	redraw_terrain()

func print_object_properties(obj):
	var prop_list = obj.get_property_list()
	for prop in prop_list:
		var prop_name = prop.name
		var prop_value = obj.get(prop_name)
		print(prop_name + ": " + str(prop_value))
