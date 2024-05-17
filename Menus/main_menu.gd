extends Node2D

func _ready():
	var savefile = null
	if(Globals.running == false):
		Globals.running = true
		#Load Save Game State
		if(FileAccess.file_exists(Globals.backupsavelocation)):
			DirAccess.rename_absolute(Globals.backupsavelocation, Globals.savelocation)
			savefile = FileAccess.open(Globals.savelocation, FileAccess.READ)
			print("BACKUP Save Found")
		elif(FileAccess.file_exists(Globals.savelocation)):
			savefile = FileAccess.open(Globals.savelocation, FileAccess.READ)
			print("Save Found")
		else:
			savefile = null
			print("NO Save")
		
		
		#Initialize ship array
		for i in Globals.ship_max_height:
			Globals.ship_config.append([])
			for j in Globals.ship_max_width:
				Globals.ship_config[i].append("0")
		#Load Default Ship if no ship file
		if(savefile == null):
			var centerheight = Globals.ship_max_height / 2
			var centerwidth = Globals.ship_max_width / 2 
			#Top row left to right
			Globals.ship_config[centerheight+1][centerwidth-1] = "Hull"
			Globals.ship_config[centerheight+1][centerwidth] = "Hull"
			Globals.ship_config[centerheight+1][centerwidth+1] = "Hull"
			#Center row left to right
			Globals.ship_config[centerheight][centerwidth-1] = "Propeller"
			Globals.ship_config[centerheight][centerwidth] = "Bridge"
			Globals.ship_config[centerheight][centerwidth+1] = "Gun"
			#Bottom row left to right
			Globals.ship_config[centerheight-1][centerwidth-1] = "Hull"
			Globals.ship_config[centerheight-1][centerwidth] = "Hull"
			Globals.ship_config[centerheight-1][centerwidth+1] = "Hull"
		else:
			#load ship config from file
			var saveline=true
			while(!savefile.eof_reached()):
				saveline = savefile.get_csv_line()
				#link variables here
				if(saveline[0]=="ship_config"):
					for i in Globals.ship_max_width:
						Globals.ship_config[int(saveline[1])][i] = saveline[i+2]
				elif(saveline[0]=="cash"):
					Globals.PLAYER_CURRENCY = int(saveline[1])
					

func _on_ship_builder_pressed():
	get_tree().change_scene_to_file("res://Menus/ShipBuilder/ship_builder.tscn")
	
func _on_mission_select_pressed():
	get_tree().change_scene_to_file("res://Menus/mission_select.tscn")

func _on_exit_game_pressed():
	#Save Game State
	
	for i in Globals.ship_max_height:
		for j in Globals.ship_max_width:
			if(Globals.ship_config[j][i] != "0"):
				print(i, ",", j, " - ", Globals.ship_config[j][i])
				
				
	if(FileAccess.file_exists(Globals.savelocation)):
		print("Save File Found on Unload")
		DirAccess.rename_absolute(Globals.savelocation, Globals.backupsavelocation)
	var csvline = []
	var savefile = FileAccess.open(Globals.savelocation,FileAccess.WRITE)
	#Save Ship Parts
	for i in Globals.ship_max_height:
		csvline = []
		csvline.append("ship_config")
		csvline.append(i)
		for j in Globals.ship_max_width:
			csvline.append(Globals.ship_config[i][j])
		savefile.store_csv_line(csvline)
	#Save Cash
	csvline = []
	csvline.append("cash")
	csvline.append(Globals.PLAYER_CURRENCY)
	savefile.store_csv_line(csvline)
	#Remove backup save if no errors
	DirAccess.remove_absolute (Globals.backupsavelocation)
	get_tree().quit()
