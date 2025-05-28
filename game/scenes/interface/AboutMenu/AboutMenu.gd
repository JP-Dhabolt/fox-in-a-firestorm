class_name AboutMenu extends ColorRect

@onready var version_label: Label = find_child("VersionLabel")
@onready var return_button: Button = find_child("ReturnButton")

signal return_to_main_menu_requested()

func _ready() -> void:
	version_label.text = "Version: " + ProjectSettings.get_setting("application/config/version")
	return_button.pressed.connect(_on_return_button_pressed)

func _on_return_button_pressed() -> void:
	return_to_main_menu_requested.emit()
	hide()
