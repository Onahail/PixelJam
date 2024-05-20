extends Node2D

const MUSIC = preload("res://Music/MenuMusic.wav")

func _ready():
	if !MenuMusic.playing:
		MenuMusic.stream = MUSIC
	MenuMusic.play()
	#$PlayerShip.load_ship()
	#$PlayerShip.scale = Vector2(.6,.6)
	
	if Globals.PLAYER_WIN == true:
		$SuccessBackground.show()
		$FailBackground.hide()
		var color = Color(Color.DARK_BLUE)
		$Stats.set("theme_override_colors/font_color",color)
		var earnings = ((((Globals.DIFFICULTY - Globals.DIFF_SCALE_START) / (Globals.DIFF_SCALE_START - Globals.DIFF_SCALE_END)) * (Globals.CURRENCY_SCALE_START - Globals.CURRENCY_SCALE_END)) + Globals.CURRENCY_SCALE_START) * Globals.RESOURCES_COLLECTED
		Globals.PLAYER_CURRENCY += int(earnings)
		$Stats.text = str("
		Congratulations, Captain! The HDS Venturer is brimming with Hydrium! Thanks to your skilled navigation and sharp instincts, you've harvested a fortune from the depths. 
		The energy potential is immense, and your success ensures a brighter future for all on the surface. 
		Your bravery and expertise have opened new horizons for underwater exploration. Rest up, Captain—more adventures await beyond the abyss. 
		\nYou collected ", int(Globals.RESOURCES_COLLECTED), " resources worth ", int(earnings), "$.")
	else:
		$SuccessBackground.hide()
		$FailBackground.show()
		var color = Color(Color.WHITE)
		$Stats.set("theme_override_colors/font_color",color)
		#TODO Better loss message
		$Stats.text = ("Alas, Captain, the HDS Venturer has succumbed to the unforgiving depths. While the ocean's treasures were within reach, its guardians proved too formidable this time. We mourn the loss but celebrate the bravery and spirit you showed in facing the abyss. 
		Remember, each failure is a stepping stone to success. Repair, rebuild, and ready yourself— the depths still hold secrets waiting for the daring to uncover them.")
		
	Globals.PLAYER_WIN = null

func _on_return_to_menu_pressed():
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")


func _on_return_to_ship_builder_pressed():
	get_tree().change_scene_to_file("res://Menus/ShipBuilder/ship_builder.tscn")
