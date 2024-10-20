extends ColorRect

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var continue_button: Button = find_child("ContinueButton")
@onready var restart_button: Button = find_child("RestartButton")
@onready var menu_exit_button: Button = find_child("MenuExitButton")
@onready var desktop_exit_button: Button = find_child("DesktopExitButton")

var hide_quit_on_plaform: bool = OS.get_name() == "Web"

# Called when the node enters the scene tree for the first time.
func _ready():
	continue_button.pressed.connect(unpause)
	restart_button.pressed.connect(_reload_scene)
	menu_exit_button.pressed.connect(_load_menu)
	desktop_exit_button.pressed.connect(get_tree().quit)

	if hide_quit_on_plaform:
		desktop_exit_button.queue_free()

	hide()

func pause():
	show()
	animation_player.play("Pause")
	get_tree().paused = true
	continue_button.grab_focus()

func unpause():
	animation_player.play("Unpause")
	hide()
	get_tree().paused = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			unpause()
		else:
			pause()

func _reload_scene():
	unpause()
	get_tree().reload_current_scene()

func _load_menu():
	unpause()
	get_tree().change_scene_to_file("res://scenes/levels/Main.tscn")
