extends Line2D

@export var number_of_segments: int = 100
var desired_height: float

var velocity: float = 0
var spring_constant: float = 0.015
var damping_constant: float = 0.03
var spread: float = 0.0002
var passes: int = 25
var springs: Array[Spring] = []

func _ready():
	var screensize = get_viewport().get_visible_rect().size
	points = PackedVector2Array()
	desired_height = screensize.y / 2
	init_line(0, screensize.x)

func init_line(start_x: float, end_x: float):
	for i in range(number_of_segments + 1):
		add_spring_point(Vector2(start_x + (end_x - start_x) / number_of_segments * i, desired_height))

func add_spring_point(pos: Vector2):
	add_point(pos)
	springs.append(Spring.new(desired_height, spring_constant, damping_constant))

func _physics_process(_delta):
	process_waves()
	if Input.is_action_just_pressed("jump"):
		var local_pos := get_local_mouse_position()
		trigger_waves(get_closest_point_index(local_pos), local_pos.y * 0.1)

func trigger_waves(point_index: int, impact_force: float):
	var spring := springs[point_index]
	spring.velocity += impact_force

func process_waves():
	for i in range(get_point_count()):
		var spring_pos := get_point_position(i)
		var spring = springs[i]
		var new_y = spring.determine_new_y(spring_pos.y, desired_height)
		set_point_position(i, Vector2(spring_pos.x, new_y))

	var left_deltas: Array[float] = []
	var right_deltas: Array[float] = []
	left_deltas.resize(get_point_count())
	right_deltas.resize(get_point_count())

	for j in range(passes):
		for i in range(get_point_count()):
			if i > 0:
				var spring = springs[i - 1]
				left_deltas[i] = spread * (get_point_position(i).y - get_point_position(i - 1).y)
				spring.velocity += left_deltas[i]
			if i < get_point_count() - 1:
				var spring = springs[i + 1]
				right_deltas[i] = spread * (get_point_position(i).y - get_point_position(i + 1).y)
				spring.velocity += right_deltas[i]

func get_closest_point_index(pos: Vector2) -> int:
	var distance: float = INF
	var index: int = 0

	for i in range(get_point_count()):
		var new_distance: float = abs(pos.x - points[i].x)
		if new_distance < distance:
			distance = new_distance
			index = i

	return index
