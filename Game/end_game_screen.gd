extends Node2D

func _ready():
	if Globals.PLAYER_WIN == true:
		var earnings = (((Globals.DIFFICULTY / (Globals.DIFF_SCALE_START - Globals.DIFF_SCALE_END)) * (Globals.CURRENCY_SCALE_START - Globals.CURRENCY_SCALE_END)) + Globals.CURRENCY_SCALE_START) * Globals.RESOURCES_COLLECTED
		Globals.PLAYER_CURRENCY += int(earnings)
		$Stats.text = str("You collected ", int(Globals.RESOURCES_COLLECTED), " resources worth ", int(earnings), "$.")
	else:
		#TODO Better loss message
		$Stats.text = str("You suck")
	

func _on_return_to_menu_pressed():
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")


func _on_return_to_ship_builder_pressed():
	get_tree().change_scene_to_file("res://Menus/ShipBuilder/ship_builder.tscn")
