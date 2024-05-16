extends Node2D

#
#

func load_ship():
	print("LOAD SHIP CALLED")
	#Calculate Screen Center
	var centerx = ($".".get_viewport().get_visible_rect().size.x) / 2
	var centery = ($".".get_viewport().get_visible_rect().size.y) / 2
	#Define Module Size
	var moduleheight = 62
	var modulewidth = 75
	#Nudge variables for fine tuning or moving the whole ship
	var nudgex = 0
	var nudgey = 0
	#Enumerate Modules Types
	var modules = []
	for module in ModuleStats.module_data:
		modules.append(str(module))
	#Load Globals.ship_config
	for i in Globals.ship_max_height:
		for j in Globals.ship_max_width:
			print(i, ",", j, " - ", Globals.ship_config[i][j])
			if(Globals.ship_config[i][j] == "0"):
				
				continue
			else:
				#Calculate relative Module Position
				#Determine of module is on even or odd column to align hexes
				var yoffset = 0
				if(i%2 == 0):
					yoffset = moduleheight / 2
				var yposition = int(centery - yoffset + nudgey + ((j - (Globals.ship_max_height / 2)) * moduleheight))
				var xposition = int(centerx + nudgex + ((i - (Globals.ship_max_width / 2)) * modulewidth))
				var spawnvector = Vector2(xposition,yposition)
				#Load Module
				var module = load(ModuleStats.module_data[Globals.ship_config[i][j]]["assets"]["scene"])
				var shipmod = module.instantiate()
				#Spawn Module
				shipmod.global_position = spawnvector
				#Attach Module to Ship
				$".".add_child(shipmod)
				print("Attempted to spawn ship module ", Globals.ship_config[i][j], " at position ", xposition, "," , yposition)

	
	
