extends Module


func _ready():
	
	#CHANGE VALUES
	module_name = "Shield"
	health = ModuleStats.module_data[module_name]["health"]
	price = Globals.SHIELD_PRICE
	
	#CALL ORIGINAL
	super._ready()
