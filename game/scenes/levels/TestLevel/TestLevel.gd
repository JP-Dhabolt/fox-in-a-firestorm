extends Node2D

@onready var player: Player = $Player
@onready var terrain_generator: TerrainGenerator = $TerrainGenerator

func _ready() -> void:
	GameManager.current_player = player
	GameManager.current_terrain_generator = terrain_generator
