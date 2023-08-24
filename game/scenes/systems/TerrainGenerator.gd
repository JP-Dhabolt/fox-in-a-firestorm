extends Node2D

var MAX_X = 20
var MAX_Y = 11
var MIN_X = 0
var MIN_Y = 4

@onready var tilemap := $TileMap as TileMap
@export_category("Noise")
@export var new_cell_interval_seconds: float = 0.5
@export var domain_warp_enabled: bool = false
@export var domain_warp_amplitude: float = 30.0
@export var domain_warp_fractal_gain: float = 0.5
@export var domain_warp_fractal_octaves: int = 5
@export var domain_warp_fractal_type: FastNoiseLite.DomainWarpFractalType = FastNoiseLite.DomainWarpFractalType.DOMAIN_WARP_FRACTAL_NONE
@export var domain_warp_frequency: float = 0.05
@export var domain_warp_type: FastNoiseLite.DomainWarpType = FastNoiseLite.DomainWarpType.DOMAIN_WARP_SIMPLEX
@export var fractal_gain: float = 0.5
@export var fractal_lacunarity: float = 2.0
@export var fractal_octaves: int = 5
@export var fractal_ping_pong_strength: float = 2.0
@export var fractal_weighted_strength: float = 0.0
@export var frequency: float = 0.01
@export var fractal_type: FastNoiseLite.FractalType = FastNoiseLite.FractalType.FRACTAL_FBM

var current_cell_x = 0
var elapsed_time = 0.0
var fast_noise: FastNoiseLite

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_fast_noise()
	for x in range(MIN_X, MAX_X + 5):
		_place_tile(x)

	current_cell_x = MAX_X + 5

func setup_fast_noise():
	fast_noise = FastNoiseLite.new()
	fast_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	fast_noise.domain_warp_enabled = domain_warp_enabled
	fast_noise.domain_warp_amplitude = domain_warp_amplitude
	fast_noise.domain_warp_fractal_gain = domain_warp_fractal_gain
	fast_noise.domain_warp_fractal_octaves = domain_warp_fractal_octaves
	fast_noise.domain_warp_fractal_type = domain_warp_fractal_type
	fast_noise.domain_warp_frequency = domain_warp_frequency
	fast_noise.domain_warp_type = domain_warp_type
	fast_noise.fractal_gain = fractal_gain
	fast_noise.fractal_lacunarity = fractal_lacunarity
	fast_noise.fractal_octaves = fractal_octaves
	fast_noise.fractal_ping_pong_strength = fractal_ping_pong_strength
	fast_noise.fractal_weighted_strength = fractal_weighted_strength
	fast_noise.frequency = frequency
	fast_noise.fractal_type = fractal_type

func randomize_fast_noise():
	fast_noise = FastNoiseLite.new()
	fast_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	fast_noise.domain_warp_enabled = randi_range(0, 1) == 0
	fast_noise.domain_warp_amplitude = randf_range(0.0, 100.0)
	fast_noise.domain_warp_fractal_gain = randf_range(0.0, 1.0)
	fast_noise.domain_warp_fractal_octaves = randi_range(1, 10)
	fast_noise.domain_warp_fractal_type = randi_range(0, 2) as FastNoiseLite.DomainWarpFractalType
	fast_noise.domain_warp_frequency = randf_range(0.0, 1.0)
	fast_noise.domain_warp_type = randi_range(0, 2) as FastNoiseLite.DomainWarpType
	fast_noise.fractal_gain = randf_range(0.0, 1.0)
	fast_noise.fractal_lacunarity = randf_range(0.0, 10.0)
	fast_noise.fractal_octaves = randi_range(1, 10)
	fast_noise.fractal_ping_pong_strength = randf_range(0.0, 10.0)
	fast_noise.fractal_weighted_strength = randf_range(0.0, 10.0)
	fast_noise.frequency = randf_range(0.0, 1.0)
	fast_noise.fractal_type = randi_range(0, 3) as FastNoiseLite.FractalType
	print_object_properties(fast_noise)


# # Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
# 	elapsed_time += delta
	
# 	# Add one cell to the tilemap every 2 seconds
# 	if elapsed_time > new_cell_interval_seconds:
# 		_place_tile(current_cell_x)
# 		elapsed_time -= new_cell_interval_seconds
# 		current_cell_x += 1

func _place_tile(x: int):
	var y_val = _determine_y_value(x)
	print("placing tile at x: " + str(x) + " y: " + str(y_val))
	var vectors = range(y_val, MAX_Y).map(func(y): return Vector2i(x, y))
	tilemap.set_cells_terrain_connect(0, vectors, 0, 0)

func _determine_y_value(x: int):
	var noise_value = fast_noise.get_noise_1d(x)
	var normalized_noise = (noise_value + 1) / 2
	var y_range = MAX_Y - MIN_Y
	return MIN_Y + int(normalized_noise * y_range)

func redraw_terrain():
	tilemap.clear()
	fast_noise.seed = randi()
	for x in range(MIN_X, MAX_X + 5):
		_place_tile(x)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			redraw_terrain()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			randomize_fast_noise()
			redraw_terrain()

func print_object_properties(obj):
	var prop_list = obj.get_property_list()
	for prop in prop_list:
		var prop_name = prop.name
		var prop_value = obj.get(prop_name)
		print(prop_name + ": " + str(prop_value))
