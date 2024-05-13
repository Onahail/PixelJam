extends Node2D


func _on_ship_builder_pressed():
	get_tree().change_scene_to_file("res://Menus/ShipBuilder/ship_builder.tscn")
	
func _on_mission_select_pressed():
	get_tree().change_scene_to_file("res://Menus/mission_select.tscn")

func _on_exit_game_pressed():
	get_tree().quit()
	
