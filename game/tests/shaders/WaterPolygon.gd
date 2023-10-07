@tool
extends Polygon2D

func _ready():
	connect("item_rect_changed", _on_item_rect_changed)

func _process(_delta):
	_zoom_changed()

func _zoom_changed():
	material.set_shader_parameter("y_zoom", get_viewport_transform().get_scale().y)

func _on_item_rect_changed():
	print("rect changed")
	material.set_shader_parameter("scale", scale)

func _set_uv():
	var v0 := polygon
	var x0: float = INF
	var y0: float = INF
	var x1: float = -INF
	var y1: float = -INF
	for v in v0:
		x0 = min(x0, v.x)
		x1 = max(x1, v.x)
		y0 = min(y0, v.y)
		y1 = max(y1, v.y)

	var s: float = max(x1 - x0, y1 - y0)
	var d := Vector2(s / 2, s / 2);
	var potential_uv := PackedVector2Array()
	for v in v0:
		potential_uv.append((v + d) / s)
	uv = potential_uv
