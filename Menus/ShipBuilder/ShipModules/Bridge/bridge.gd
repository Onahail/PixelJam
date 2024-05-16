extends Module


func _ready():
	
	#CHANGE VALUES
	module_name = "Bridge"
	health = ModuleStats.module_data[module_name]["health"]
	price = Globals.BRIDGE_PRICE
	
	#CALL ORIGINAL
	super._ready()
