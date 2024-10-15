@tool
extends Node2D
class_name TerrainGenerator

@export_group("Generation")
@export var spawnable_items: Array[SpawnableItem] = []
@export var water_scene: PackedScene

@export_group("Noise")
@export var force_refresh: bool = false: set = _editor_force_redraw, get = _return_false
@export var noise: FastNoiseLite

@onready var ground_layer := $GroundLayer as TileMapLayer
@onready var water_sibling := $WaterSibling as Node

signal entered_water(body: Node2D)
signal exited_water(body: Node2D)

const TILE_HEIGHT_IN_PIXELS: int = 16

var earliest_x_drawn: int = 0
var latest_x_drawn: int = -1
var elapsed_time = 0.0
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var instance_dict: Dictionary = {}
var water_start_dict: Dictionary = {}
var water_end_dict: Dictionary = {}

var max_x: int
var min_x: int = 0
var max_y: int = 12
var depth: int = 36
var min_y: int
var water_height_in_tiles: int

var is_processing_right: bool = true
var is_in_body_of_water: bool = false
var water_start_x: int
var water_end_x: int

const TERRAIN_SETS = {
	"GROUND": 0,
}
const TERRAINS = {
	"GROUND": 0,
}

func _ready():
	ground_layer.clear()
	var viewport_rect = get_viewport_rect()
	max_x = ceil(viewport_rect.size.x / TILE_HEIGHT_IN_PIXELS)

	if not Engine.is_editor_hint():
		max_y = ceil(viewport_rect.size.y / TILE_HEIGHT_IN_PIXELS)
		noise.seed = randi()

	min_y = ceil(max_y / 3.0)
	water_height_in_tiles = min_y * 2
	_draw_and_clear_map(0)

func _verify_spawnable_items():
	var total_spawn_chance = 0.0
	for item in spawnable_items:
		total_spawn_chance += item.spawn_chance
	if total_spawn_chance > 1.0:
		push_warning("Total spawn chance is greater than 1.0. This will cause items later in the array to not spawn.")

func _process(_delta):
	if not Engine.is_editor_hint():
		var player_node_x = ground_layer.local_to_map(GameManager.current_player.global_position).x
		_draw_and_clear_map(player_node_x)

func _draw_and_clear_map(player_x: int):
	_draw_right_if_needed(player_x)
	_draw_left_if_needed(player_x)
	_clear_right_if_needed(player_x)
	_clear_left_if_needed(player_x)

func _draw_right_if_needed(player_x: int):
	is_processing_right = true
	if player_x + max_x > latest_x_drawn:
		for x in range(latest_x_drawn + 1, player_x + max_x + 1):
			_place_tile(x)
		latest_x_drawn = player_x + max_x

		while is_in_body_of_water:
			_place_tile(latest_x_drawn + 1)
			latest_x_drawn += 1

func _draw_left_if_needed(player_x: int):
	is_processing_right = false
	if player_x - max_x < earliest_x_drawn:
		for x in range(earliest_x_drawn - 1, player_x - max_x - 1, -1):
			_place_tile(x)
		earliest_x_drawn = player_x - max_x

		while is_in_body_of_water:
			_place_tile(earliest_x_drawn - 1)
			earliest_x_drawn -= 1

func _clear_right_if_needed(player_x: int):
	is_processing_right = true
	if player_x + max_x * 2 < latest_x_drawn:
		for x in range(player_x + max_x, latest_x_drawn + 1):
			_erase_tile(x)
		latest_x_drawn = player_x + max_x - 1

func _clear_left_if_needed(player_x: int):
	is_processing_right = false
	if player_x - max_x * 2 > earliest_x_drawn:
		for x in range(player_x - max_x, earliest_x_drawn - 1, -1):
			_erase_tile(x)
		earliest_x_drawn = player_x - max_x + 1

func draw_water():
	# Add a buffer to either end to prevent ensure enough waterline exists for rendering
	var actual_water_start_x: int = min(water_start_x, water_end_x) - 1
	var actual_water_end_x: int = max(water_start_x, water_end_x) + 1

	# Processing the left results in tiles being shifted by 1
	if not is_processing_right:
		actual_water_start_x += 1
		actual_water_end_x += 1

	var water_start: int = actual_water_start_x * TILE_HEIGHT_IN_PIXELS
	var water_end: int = actual_water_end_x * TILE_HEIGHT_IN_PIXELS
	var water_height := water_height_in_tiles * TILE_HEIGHT_IN_PIXELS + int(float(TILE_HEIGHT_IN_PIXELS) / 4)
	var water = water_scene.instantiate() as Water
	water_sibling.add_sibling(water)
	water.setup_waterline(water_start, water_end, water_height)
	water.entered_water.connect(_on_water_entered_water)
	water.exited_water.connect(_on_water_exited_water)
	water_start_dict[actual_water_start_x] = {"node": water, "end": actual_water_end_x}
	water_end_dict[actual_water_end_x] = {"node": water, "start": actual_water_start_x}

func _place_tile(x: int):
	var y_val = _determine_y_value(x)
	var vectors = range(y_val, depth).map(func(y): return Vector2i(x, y))
	ground_layer.set_cells_terrain_connect(vectors, TERRAIN_SETS.GROUND, TERRAINS.GROUND)
	if y_val <= water_height_in_tiles:
		_place_objects(x, y_val)
		if is_in_body_of_water:
			if is_processing_right:
				water_end_x = x
			else:
				water_start_x = x

			draw_water()
			is_in_body_of_water = false

	if y_val > water_height_in_tiles:
		if !is_in_body_of_water:
			is_in_body_of_water = true
			if is_processing_right:
				water_start_x = x
			else:
				water_end_x = x

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
	_erase_water(x)

func _erase_object(x: int):
	if instance_dict.has(x):
		var instance = instance_dict[x]
		instance.queue_free()
		instance_dict.erase(x)

func _erase_water(x: int):
	if is_processing_right:
		if water_start_dict.has(x):
			var water = water_start_dict[x]["node"]
			var water_end = water_start_dict[x]["end"]
			water.queue_free()
			water_start_dict.erase(x)
			water_end_dict.erase(water_end)
	elif water_end_dict.has(x):
		var water = water_end_dict[x]["node"]
		var water_start = water_end_dict[x]["start"]
		water.queue_free()
		water_end_dict.erase(x)
		water_start_dict.erase(water_start)

func _determine_y_value(x: int):
	var noise_value = noise.get_noise_1d(x)
	var normalized_noise = (noise_value + 1) / 2
	var y_range = max_y - min_y
	return min_y + int(normalized_noise * y_range)

func redraw_terrain():
	ground_layer.clear()

	for obj in instance_dict.values():
		obj.queue_free()
	instance_dict.clear()

	for water in water_start_dict.values():
		water["node"].queue_free()
	water_start_dict.clear()
	water_end_dict.clear()

	noise.seed = randi()

	for x in range(earliest_x_drawn, latest_x_drawn + 1):
		_place_tile(x)

func _on_water_entered_water(body: Node2D):
	entered_water.emit(body)

func _on_water_exited_water(body: Node2D):
	exited_water.emit(body)

func _editor_force_redraw(_irrelevant: bool):
	if not Engine.is_editor_hint() or not is_node_ready():
		return

	redraw_terrain()
	noise.seed = 0

func _return_false():
	return false
