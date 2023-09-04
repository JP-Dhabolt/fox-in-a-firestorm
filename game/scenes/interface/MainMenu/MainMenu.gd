extends ColorRect

@onready var test_level_button: Button = find_child("TestLevelButton")
@onready var quit_button: Button = find_child("QuitButton")

# Called when the node enters the scene tree for the first time.
func _ready():
	test_level_button.pressed.connect(_load_test_level)
	quit_button.pressed.connect(get_tree().quit)
	test_level_button.grab_focus()

func _load_test_level():
	get_tree().change_scene_to_file("res://scenes/levels/TestLevel/TestLevel.tscn")
