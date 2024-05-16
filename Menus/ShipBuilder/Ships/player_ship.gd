extends Node2D

#
#

func load_ship():
	#Calculate Screen Center
	var centerx = ($".".get_viewport().get_visible_rect().size.x) / 2
	var centery = ($".".get_viewport().get_visible_rect().size.y) / 2
	#Define Module Size
	var moduleheight = 100
	var modulewidth = 200
	#Nudge variables for fine tuning or moving the whole ship
	var nudgex = 0
	var nudgey = 0
	print("loading")
	#Enumerate Modules Types
	for module in ModuleStats.module_data:
		print(str(module))
		pass
	#Load Globals.ship_config
	for i in Globals.ship_max_height:
		for j in Globals.ship_max_width:
			if(Globals.ship_config[i][j] == 0):
				continue
			else:
				#Calculate relative Module Position
				#Determine of module is on even or odd column to align hexes
				var yoffset = 0
				if(j%2 == 0):
					yoffset = moduleheight / 2
				var yposition = centery - yoffset + nudgey + ((j - (Globals.ship_max_height / 2)) * moduleheight)
				var xposition = centerx + nudgex + ((i - (Globals.ship_max_width / 2)) * modulewidth)
				var spawnvector = Vector2(xposition,yposition)
				#Determine Module Type
				
				#Preload Module
				
				#Spawn Module
				
				#Attach Module to Ship
				

	
	
