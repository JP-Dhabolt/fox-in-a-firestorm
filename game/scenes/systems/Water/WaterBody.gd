@tool
extends Polygon2D
class_name WaterBody

@export var control_point_distance: float = 4

@onready var collision: CollisionShape2D = $Area2D/CollisionShape2D

func _ready():
	polygon = PackedVector2Array()
	_zoom_changed()
	_on_item_rect_changed()

func draw_water(points: PackedVector2Array, depth: float):
	if points.size() < 2:
		print_debug("Not Renderable")

	var water_body = _determine_curve(points, control_point_distance)
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
	var end_dir = input[-2].direction_to(input[-1])
	curve.add_point(input[-1], - end_dir * dist, end_dir * dist)

	return curve.get_baked_points()


func _on_item_rect_changed():
	material.set_shader_parameter("scale", scale)

func _zoom_changed():
	material.set_shader_parameter("y_zoom", get_viewport_transform().get_scale().y)
