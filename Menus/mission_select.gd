extends Node2D

func _ready():
	var globals = get_node("res://Globals.gd")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")

func _on_mission_start_pressed():
	get_tree().change_scene_to_file("res://Game/game.tscn")

func _on_depth_selection_pressed():
	print(Globals.testvar)
