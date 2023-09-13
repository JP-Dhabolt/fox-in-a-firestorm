@tool
extends Node2D
class_name TerrainGenerator

@onready var tilemap := $TileMap as TileMap
@export var player_node: Node2D
@export var spawnable_items: Array[SpawnableItem] = []

var earliest_x_drawn: int = 0
var latest_x_drawn: int = 0
var elapsed_time = 0.0
var fast_noise: FastNoiseLite
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var instance_dict: Dictionary = {}

var max_x: int
var min_x: int = 0
var max_y: int = 12
var min_y: int
var water_height: int

const LAYERS = {
	"GROUND": 0,
	"WATER": 1
}
const TERRAIN_SETS = {
	"GROUND": 0,
	"WATER": 1
}
const TERRAINS = {
	"GROUND": 0,
	"WATER": 0
}

# Called when the node enters the scene tree for the first time.
func _ready():
	tilemap.clear()
	fast_noise = NoiseForTerrain.get_noise_by_type(NoiseForTerrain.NoiseForTerrainType.INITIAL)
	var viewport_rect = get_viewport_rect()
	max_x = ceil(viewport_rect.size.x / 16)
	if not Engine.is_editor_hint():
		max_y = ceil(viewport_rect.size.y / 16)
	min_y = ceil(max_y / 3.0)
	water_height = min_y * 2
	for x in range(min_x, max_x + 5):
		_place_tile(x)
	_draw_left_boundary()

	latest_x_drawn = max_x + 5

func _verify_spawnable_items():
	var total_spawn_chance = 0.0
	for item in spawnable_items:
		total_spawn_chance += item.spawn_chance
	if total_spawn_chance > 1.0:
		push_warning("Total spawn chance is greater than 1.0. This will cause items later in the array to not spawn.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not Engine.is_editor_hint():
		var player_node_x = tilemap.local_to_map(player_node.global_position).x
		_draw_and_clear_map(player_node_x)

func _draw_and_clear_map(player_x: int):
	_draw_right_if_needed(player_x)
	_draw_left_if_needed(player_x)
	_clear_right_if_needed(player_x)
	_clear_left_if_needed(player_x)

func _draw_right_if_needed(player_x: int):
	if player_x + max_x > latest_x_drawn:
		for x in range(latest_x_drawn, player_x + max_x):
			_place_tile(x)
		latest_x_drawn = player_x + max_x

func _draw_left_if_needed(player_x: int):
	if max(0, player_x - max_x) < earliest_x_drawn:
		for x in range(max(0, player_x - max_x), earliest_x_drawn):
			_place_tile(x)
		earliest_x_drawn = max(0, player_x - max_x)

func _clear_right_if_needed(player_x: int):
	if player_x + max_x * 2 < latest_x_drawn:
		for x in range(player_x + max_x, latest_x_drawn):
			_erase_tile(x)
		latest_x_drawn = player_x + max_x

func _clear_left_if_needed(player_x: int):
	if player_x - max_x * 2 > earliest_x_drawn:
		for x in range(earliest_x_drawn, max(player_x - max_x, 0)):
			_erase_tile(x)
		earliest_x_drawn = max(player_x - max_x, 0)

func _place_tile(x: int):
	var y_val = _determine_y_value(x)
	var vectors = range(y_val, max_y).map(func(y): return Vector2i(x, y))
	tilemap.set_cells_terrain_connect(LAYERS.GROUND, vectors, TERRAIN_SETS.GROUND, TERRAINS.GROUND)
	if y_val > water_height:
		var water_vectors = range(water_height, y_val).map(func(y): return Vector2i(x, y))
		tilemap.set_cells_terrain_connect(LAYERS.WATER, water_vectors, TERRAIN_SETS.WATER, TERRAINS.WATER)
	else:
		_place_objects(x, y_val)

func _draw_left_boundary():
	var vectors = range(0, max_y).map(func(y): return Vector2i(-1, y))
	tilemap.set_cells_terrain_connect(LAYERS.GROUND, vectors, TERRAIN_SETS.GROUND, TERRAINS.GROUND)

func _place_objects(x: int, y: int):
	rng.seed = x
	var spawn_chance = rng.randf()
	var spawn_threshold = 0.0
	for item in spawnable_items:
		spawn_threshold += item.spawn_possibility
		if spawn_chance < spawn_threshold:
			var item_instance = item.spawn_item.instantiate()
			item_instance.position = tilemap.map_to_local(Vector2i(x, y - 1))
			add_child(item_instance)
			instance_dict[x] = item_instance
			break

func _erase_tile(x: int):
	for y in range(min_y, max_y):
		tilemap.erase_cell(LAYERS.GROUND, Vector2i(x, y))
	_erase_object(x)

func _erase_object(x: int):
	if instance_dict.has(x):
		var instance = instance_dict[x]
		instance.queue_free()
		instance_dict.erase(x)

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
	Utilities.print_object_properties(fast_noise)
	redraw_terrain()
