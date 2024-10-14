@tool
extends Node2D
class_name TerrainGenerator

@export var player_node: Node2D
@export var spawnable_items: Array[SpawnableItem] = []
@export var noise: FastNoiseLite
@export var editor_refresh_rate: float = 0.0

@onready var ground_layer := $GroundLayer as TileMapLayer
@onready var water := $Water as Water

signal entered_water(body: Node2D)
signal exited_water(body: Node2D)

const TILE_HEIGHT_IN_PIXELS: int = 16

var earliest_x_drawn: int = 0
var latest_x_drawn: int = 0
var elapsed_time = 0.0
var fast_noise: FastNoiseLite
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var instance_dict: Dictionary = {}

var max_x: int
var min_x: int = 0
var max_y: int = 12
var depth: int = 36
var min_y: int
var water_height_in_tiles: int
var water_needs_redrawn: bool = true

const TERRAIN_SETS = {
	"GROUND": 0,
}
const TERRAINS = {
	"GROUND": 0,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	ground_layer.clear()
	# water_layer.clear()
	fast_noise = NoiseForTerrain.get_noise_by_type(NoiseForTerrain.NoiseForTerrainType.INITIAL)
	var viewport_rect = get_viewport_rect()
	max_x = ceil(viewport_rect.size.x / TILE_HEIGHT_IN_PIXELS)

	if not Engine.is_editor_hint():
		max_y = ceil(viewport_rect.size.y / TILE_HEIGHT_IN_PIXELS)
		noise.seed = randi()

	min_y = ceil(max_y / 3.0)
	water_height_in_tiles = min_y * 2
	for x in range(min_x, max_x + 5):
		_place_tile(x)
	_draw_left_boundary()
	latest_x_drawn = max_x + 5
	_redraw_water_if_needed()

	if Engine.is_editor_hint() and editor_refresh_rate > 0.0:
		_editor_force_redraw()

func _verify_spawnable_items():
	var total_spawn_chance = 0.0
	for item in spawnable_items:
		total_spawn_chance += item.spawn_chance
	if total_spawn_chance > 1.0:
		push_warning("Total spawn chance is greater than 1.0. This will cause items later in the array to not spawn.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not Engine.is_editor_hint():
		var player_node_x = ground_layer.local_to_map(player_node.global_position).x
		_draw_and_clear_map(player_node_x)

func _draw_and_clear_map(player_x: int):
	_draw_right_if_needed(player_x)
	_draw_left_if_needed(player_x)
	_clear_right_if_needed(player_x)
	_clear_left_if_needed(player_x)
	_redraw_water_if_needed()

func _draw_right_if_needed(player_x: int):
	if player_x + max_x > latest_x_drawn:
		for x in range(latest_x_drawn, player_x + max_x):
			_place_tile(x)
		latest_x_drawn = player_x + max_x
		water_needs_redrawn = true

func _draw_left_if_needed(player_x: int):
	if max(0, player_x - max_x) < earliest_x_drawn:
		for x in range(max(0, player_x - max_x), earliest_x_drawn):
			_place_tile(x)
		earliest_x_drawn = max(0, player_x - max_x)
		water_needs_redrawn = true

func _clear_right_if_needed(player_x: int):
	if player_x + max_x * 2 < latest_x_drawn:
		for x in range(player_x + max_x, latest_x_drawn):
			_erase_tile(x)
		latest_x_drawn = player_x + max_x
		water_needs_redrawn = true

func _clear_left_if_needed(player_x: int):
	if player_x - max_x * 2 > earliest_x_drawn:
		for x in range(earliest_x_drawn, max(player_x - max_x, 0)):
			_erase_tile(x)
		earliest_x_drawn = max(player_x - max_x, 0)
		water_needs_redrawn = true

func _redraw_water_if_needed():
	if water_needs_redrawn:
		water_needs_redrawn = false
		var water_start := (earliest_x_drawn - max_x) * TILE_HEIGHT_IN_PIXELS
		var water_end := latest_x_drawn * TILE_HEIGHT_IN_PIXELS
		var water_height := water_height_in_tiles * TILE_HEIGHT_IN_PIXELS + int(float(TILE_HEIGHT_IN_PIXELS) / 4)
		water.setup_waterline(water_start, water_end, water_height)

func _place_tile(x: int):
	var y_val = _determine_y_value(x)
	var vectors = range(y_val, depth).map(func(y): return Vector2i(x, y))
	ground_layer.set_cells_terrain_connect(vectors, TERRAIN_SETS.GROUND, TERRAINS.GROUND)
	if y_val <= water_height_in_tiles:
		_place_objects(x, y_val)

func _draw_left_boundary():
	var vectors = range(0, max_y).map(func(y): return Vector2i(-1, y))
	ground_layer.set_cells_terrain_connect(vectors, TERRAIN_SETS.GROUND, TERRAINS.GROUND)

func _place_objects(x: int, y: int):
	rng.seed = x
	var spawn_chance = rng.randf()
	var spawn_threshold = 0.0
	for item in spawnable_items:
		spawn_threshold += item.spawn_possibility
		if spawn_chance < spawn_threshold:
			var item_instance = item.spawn_item.instantiate()
			item_instance.position = ground_layer.map_to_local(Vector2i(x, y - 1))
			add_child(item_instance)
			instance_dict[x] = item_instance
			break

func _erase_tile(x: int):
	for y in range(min_y, max_y):
		ground_layer.erase_cell(Vector2i(x, y))
	_erase_object(x)

func _erase_object(x: int):
	if instance_dict.has(x):
		var instance = instance_dict[x]
		instance.queue_free()
		instance_dict.erase(x)

func _determine_y_value(x: int):
	# var noise_value = fast_noise.get_noise_1d(x)
	var noise_value = noise.get_noise_1d(x)
	var normalized_noise = (noise_value + 1) / 2
	var y_range = max_y - min_y
	return min_y + int(normalized_noise * y_range)

func redraw_terrain():
	ground_layer.clear()
	# fast_noise.seed = randi()
	if not Engine.is_editor_hint():
		noise.seed = randi()
	for x in range(earliest_x_drawn, latest_x_drawn):
		_place_tile(x)

func randomize_terrain():
	fast_noise = NoiseForTerrain.get_noise_by_type(NoiseForTerrain.NoiseForTerrainType.RANDOM)
	Utilities.print_object_properties(fast_noise)
	redraw_terrain()


func _on_water_entered_water(body: Node2D):
	entered_water.emit(body)

func _on_water_exited_water(body: Node2D):
	exited_water.emit(body)

func _editor_force_redraw():
	redraw_terrain()
	get_tree().create_timer(editor_refresh_rate).timeout.connect(_editor_force_redraw)
