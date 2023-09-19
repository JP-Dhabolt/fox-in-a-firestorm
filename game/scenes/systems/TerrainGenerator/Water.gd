extends Node2D

@onready var water_body: WaterBody = $WaterBody
@export var distance_between_points: float = 5

var water_line: WaterSprings

func _ready():
	var screensize := get_viewport().get_visible_rect().size
	var desired_height := screensize.y / 2
	water_line = WaterSprings.new(0, screensize.x, desired_height, distance_between_points)

func _physics_process(_delta):
	water_line.process_waves()
	water_body.draw_water(water_line.points)
	if Input.is_action_just_pressed("jump"):
		var local_pos := get_local_mouse_position()
		water_line.trigger_waves(local_pos, local_pos.y * 0.1)
