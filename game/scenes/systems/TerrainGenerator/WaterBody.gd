extends Polygon2D
class_name WaterBody

@export var depth: float = 1000
@export var distance: float = 5

func _ready():
	polygon = PackedVector2Array()

func draw_water(points: PackedVector2Array):
	var water_body = _determine_curve(points, distance)
	water_body.append(Vector2(points[-1].x, depth))
	water_body.append(Vector2(points[0].x, depth))
	polygon = water_body

func _determine_curve(input: PackedVector2Array, dist: float) -> PackedVector2Array:
	#dist determines length of controls, set dist = 0 for no smoothing
	var curve = Curve2D.new()

	#calculate first point
	var start_dir = input[0].direction_to(input[1])
	curve.add_point(input[0], - start_dir * dist, start_dir * dist)

	#calculate middle points
	for i in range(1, input.size() - 1):
		var dir = input[i-1].direction_to(input[i+1])
		curve.add_point(input[i], -dir * dist, dir * dist)

	#calculate last point
	var end_dir = input[-1].direction_to(input[-2])
	curve.add_point(input[-1], - end_dir * dist, end_dir * dist)

	return curve.get_baked_points()
