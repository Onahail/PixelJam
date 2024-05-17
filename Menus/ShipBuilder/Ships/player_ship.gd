extends Node2D

var hulls = []
func save_ship():
	print("SaveCalled")
	for i in Globals.ship_max_height:
		for j in Globals.ship_max_width:
			Globals.ship_config[j][i] = "0"
	for hull in hulls:
		print(hull)
		var childfound = false
		for child in hull.get_children():
			print(child)
			if(child is Module):
				Globals.ship_config[hull.x][hull.y] = child.module_name
				childfound = true
		if(childfound == false):
			Globals.ship_config[hull.x][hull.y] = "Hull"
	for i in Globals.ship_max_height:
		for j in Globals.ship_max_width:
			if(Globals.ship_config[j][i] != "0"):
				print(i, ",", j, " - ", Globals.ship_config[j][i])


func load_ship(isshipbuilder :bool = false):
	#Calculate Screen Center
	var centerx = ($".".get_viewport().get_visible_rect().size.x) / 2
	var centery = ($".".get_viewport().get_visible_rect().size.y) / 2
	#Define Module Size
	var moduleheight = 64
	var modulewidth = 76
	#Nudge variables for fine tuning or moving the whole ship
	var nudgex = 0
	var nudgey = 0
	#Enumerate Modules Types
	var modules = []
	#Reset Module Count
	for glomod in Globals.modulesOnShip:
		Globals.modulesOnShip[glomod] = 0
	for module in ModuleStats.module_data:
		modules.append(str(module))
	#Load Globals.ship_config
	for i in Globals.ship_max_height:
		for j in Globals.ship_max_width:
			if(Globals.ship_config[j][i] == "0"):
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
				var module = load(ModuleStats.module_data["Hull"]["assets"]["scene"])
				var hullmod = module.instantiate()
				hullmod.global_position = spawnvector
				hullmod.x = j
				hullmod.y = i
				hulls.append(hullmod)
				$".".add_child(hullmod)
				#print(hullmod)
				if(Globals.ship_config[j][i] != "Hull"):
					module = load(ModuleStats.module_data[Globals.ship_config[j][i]]["assets"]["scene"])
					var shipmod = module.instantiate()
					#Spawn Module
					shipmod.global_position = Vector2(0,0)
					#Attach Module to Ship
					hullmod.add_child(shipmod)
					shipmod.purchased = true
					hullmod.purchased = true
					Globals.modulesOnShip[Globals.ship_config[j][i]] += 1
