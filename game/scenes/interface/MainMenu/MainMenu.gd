class_name MainMenu extends ColorRect

@onready var test_level_button: Button = find_child("TestLevelButton")
@onready var about_button: Button = find_child("AboutButton")
@onready var quit_button: Button = find_child("QuitButton")

signal about_menu_requested()

var hide_quit_on_plaform: bool = OS.get_name() == "Web"

# Called when the node enters the scene tree for the first time.
func _ready():
	_setup_test_level_button()
	_setup_about_button()
	_setup_quit_button()

func _load_test_level():
	get_tree().change_scene_to_file("res://scenes/levels/TestLevel/TestLevel.tscn")

func _setup_test_level_button():
	test_level_button.pressed.connect(_load_test_level)
	test_level_button.grab_focus()

func _setup_about_button():
	about_button.pressed.connect(_about_menu_requested)

func _about_menu_requested():
	about_menu_requested.emit()
	hide()

func _setup_quit_button():
	if hide_quit_on_plaform:
		quit_button.queue_free()
		return

	quit_button.pressed.connect(get_tree().quit)
