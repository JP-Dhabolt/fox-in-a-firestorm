extends Node2D

@onready var main_menu: MainMenu = find_child("MainMenu")
@onready var about_menu: AboutMenu = find_child("AboutMenu")

func _ready() -> void:
	main_menu.about_menu_requested.connect(_on_about_menu_requested)
	about_menu.return_to_main_menu_requested.connect(_on_return_to_main_menu_requested)
	
	main_menu.show()
	about_menu.hide()

func _on_about_menu_requested() -> void:
	about_menu.show()
	main_menu.hide()

	about_menu.grab_focus()

func _on_return_to_main_menu_requested() -> void:
	main_menu.show()
	about_menu.hide()
	
	main_menu.grab_focus()
