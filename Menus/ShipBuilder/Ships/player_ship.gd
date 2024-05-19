extends Node2D

#var hulls = [] #Reference to all hulls, and thus their child modules

func save_ship():
	#Zero out the ship config before saving where the modules are
	for i in Globals.ship_max_height:
		for j in Globals.ship_max_width:
			Globals.ship_config[j][i] = "0"
	for hull in Globals.HULLS:
		var childfound = false
		#Check if the hull has a module attached
		for child in hull.get_node("HullTile").get_children():
			if(child is Module):
				Globals.ship_config[hull.x][hull.y] = child.module_name
				childfound = true
				break
		#If there are no modules attached to the hull, save a blank hull.
		if(childfound == false):
			Globals.ship_config[hull.x][hull.y] = "Hull"


func load_ship():
	Globals.HULLS = []
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
	for module in ModuleStats.module_data:
		modules.append(str(module))
	#Reset Module Count
	for glomod in Globals.modulesOnShip:
		Globals.modulesOnShip[glomod] = 0
	#Load Globals.ship_config
	for i in Globals.ship_max_height:
		for j in Globals.ship_max_width:
			if(Globals.ship_config[j][i] == "0"): #If grid position contains no Hull or Modules, place expansion marker if in ship builder
				if get_tree().current_scene.name == "ShipBuilder":
					#Calculate relative Module Position
					#Determine of module is on even or odd column to align hexes
					var yoffset = 0
					if(i%2 == 0):
						yoffset = moduleheight / 2 
					var yposition = int(centery - yoffset + nudgey + ((j - (Globals.ship_max_height / 2)) * moduleheight)) 
					var xposition = int(centerx + nudgex + ((i - (Globals.ship_max_width / 2)) * modulewidth)) 
					var spawnvector = Vector2(xposition,yposition)
					#Load Hull Module, every tile has a hull underneath
					var marker = load(ModuleStats.module_data["Hull"]["assets"]["expansion_marker"])
					var hull_marker = marker.instantiate()
					hull_marker.global_position = spawnvector
					#Save grid position to hull for use in reloads and saving to file
					hull_marker.x = j
					hull_marker.y = i
					#Globals.HULLS.append(hullmod)
					$".".add_child(hull_marker)
				else:
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
				#Load Hull Module, every tile has a hull underneath
				var module = load(ModuleStats.module_data["Hull"]["assets"]["scene"])
				var hullmod = module.instantiate()
				hullmod.global_position = spawnvector
				#Save grid position to hull for use in reloads and saving to file
				hullmod.x = j
				hullmod.y = i
				Globals.HULLS.append(hullmod)
				$".".add_child(hullmod)
				#Set the purchased flags so the object acts as if it was added from the store
				hullmod.purchased = true
				Globals.modulesOnShip["Hull"] += 1
				#If a module needs to be loaded on top of the hull, do so
				if(Globals.ship_config[j][i] != "Hull"):
					module = load(ModuleStats.module_data[Globals.ship_config[j][i]]["assets"]["scene"])
					var shipmod = module.instantiate()
					#Spawn Module on hull position, 0,0 is realitve to the hull position
					shipmod.global_position = Vector2(0,0)
					#Attach Module to Hull
					hullmod.get_node("HullTile").add_child(shipmod)
					#Set the purchased flags so the object acts as if it was added from the store
					shipmod.purchased = true
					#Add the module to the module limits check
					Globals.modulesOnShip[Globals.ship_config[j][i]] += 1
					if shipmod.module_name == "Scoop" and Globals.ship_config[j-1][i] == "0":
						shipmod.FlipScoopOnLoad()
					
func _on_init_timeout():
	Globals.INITIAL_LOAD = false
