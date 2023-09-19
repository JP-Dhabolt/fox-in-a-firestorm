extends Object
class_name Waterline

var desired_height: float
var distance_between: float = 1.5

var spring_constant: float = 0.015
var damping_constant: float = 0.03
var spread: float = 0.0002
var passes: int = 10
var springs: Array[Spring] = []
var points: PackedVector2Array

func _init(start: float, end: float, waterline_height: float, distance_between_points: float):
	points = PackedVector2Array()
	desired_height = waterline_height
	distance_between = distance_between_points
	init_line(start, end)

func init_line(start_x: float, end_x: float):
	var number_of_segments = int((end_x - start_x) / distance_between)
	for i in range(number_of_segments + 1):
		add_spring_point(Vector2(start_x + (end_x - start_x) / number_of_segments * i, desired_height))

func add_spring_point(pos: Vector2):
	points.append(pos)
	springs.append(Spring.new(desired_height, spring_constant, damping_constant))

func trigger_waves(local_pos: Vector2, impact_force: float):
	var point_index := get_closest_point_index(local_pos)
	var spring := springs[point_index]
	spring.velocity += impact_force

func process_waves():
	for i in range(points.size()):
		var spring_pos := points[i]
		var spring = springs[i]
		var new_y = spring.determine_new_y(spring_pos.y, desired_height)
		points[i] = Vector2(spring_pos.x, new_y)

	for j in range(passes):
		for i in range(points.size()):
			if i > 0:
				var spring = springs[i - 1]
				var delta := spread * (points[i].y - points[i - 1].y)
				spring.velocity += delta
			if i < points.size() - 1:
				var spring = springs[i + 1]
				var delta := spread * (points[i].y - points[i + 1].y)
				spring.velocity += delta

func get_closest_point_index(pos: Vector2) -> int:
	var distance: float = INF
	var index: int = 0

	for i in range(points.size()):
		var new_distance: float = abs(pos.x - points[i].x)
		if new_distance < distance:
			distance = new_distance
			index = i

	return index
