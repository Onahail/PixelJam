extends Module



func _ready():
	
	#CHANGE VALUES
	module_name = "Scoop"
	health = ModuleStats.module_data[module_name]["health"]
	price = Globals.SCOOP_PRICE
	
	#CALL ORIGINAL
	super._ready()
