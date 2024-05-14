extends Module

func _ready():
	
	#CHANGE VALUES
	health = Globals.BRIDGE_HEALTH
	price = Globals.BRIDGE_PRICE
	
	#CALL ORIGINAL
	super._ready()
