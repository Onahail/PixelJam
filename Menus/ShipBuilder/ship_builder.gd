extends Node2D

var draggable_bodies = [$GunModule]

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")

func _process(delta):
	pass
