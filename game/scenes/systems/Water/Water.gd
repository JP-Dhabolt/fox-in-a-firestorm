@tool
extends Node2D
class_name Water

@export var distance_between_points: float = 5
@export var default_impact_force: float = 1
@export var depth: float = 1000

@onready var water_body: WaterBody = $WaterBody

signal entered_water(body: Node2D)
signal exited_water(body: Node2D)

var water_line: WaterSprings

func _ready():
	if Engine.is_editor_hint():
		var screensize := get_viewport().get_visible_rect().size
		var desired_height := screensize.y / 2
		setup_waterline(0, screensize.x, desired_height)
		water_line.process_waves()
		water_body.draw_water(water_line.points, depth)

func setup_waterline(x_start: float, x_end: float, desired_height: float):
	water_line = WaterSprings.new(x_start, x_end, desired_height, distance_between_points)
	water_body.collision.position = Vector2(x_end - (x_end - x_start) / 2, desired_height + depth / 2)
	var rectangle_shape := RectangleShape2D.new()
	rectangle_shape.size = Vector2(x_end - x_start, depth)
	water_body.collision.shape = rectangle_shape

func _physics_process(_delta):
	if not Engine.is_editor_hint():
		if water_line:
			water_line.process_waves()
			water_body.draw_water(water_line.points, depth)

func _on_area_2d_body_entered(body: Node2D):
	entered_water.emit(body)
	var local_pos := to_local(body.global_position)
	var impact_force: float = body.get_meta("impact_force", default_impact_force)
	water_line.trigger_waves(local_pos, impact_force)

func _on_area_2d_body_exited(body: Node2D):
	exited_water.emit(body)
	var local_pos := to_local(body.global_position)
	var impact_force: float = body.get_meta("impact_force", default_impact_force)
	water_line.trigger_waves(local_pos, impact_force)
