extends Module

func _ready():
	
	#CHANGE VALUES
	health = Globals.SCOOP_HEALTH
	price = Globals.SCOOP_PRICE
	
	#CALL ORIGINAL
	super._ready()
