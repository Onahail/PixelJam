extends Node2D

func _ready():
	if Globals.PLAYER_WIN == true:
		$Stats.text = str("You collected ", int(Globals.RESOURCES_COLLECTED), " resources worth ", int(Globals.RESOURCES_COLLECTED), "$.")
	else:
		#TODO Better loss message
		$Stats.text = str("You suck")
	

func _on_return_to_menu_pressed():
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")


func _on_return_to_ship_builder_pressed():
	get_tree().change_scene_to_file("res://Menus/ShipBuilder/ship_builder.tscn")
