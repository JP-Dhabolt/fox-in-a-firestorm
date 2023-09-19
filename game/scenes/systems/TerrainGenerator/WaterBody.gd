extends Polygon2D
class_name WaterBody

@export var depth: float = 1000

func _ready():
	polygon = PackedVector2Array()

func draw_water(points: PackedVector2Array):
	var water_body = points.duplicate()
	water_body.append(Vector2(points[-1].x, depth))
	water_body.append(Vector2(points[0].x, depth))
	polygon = water_body
