extends Module

func _ready():
	
	#CHANGE VALUES
	health = Globals.SHIELD_HEALTH
	price = Globals.SHIELD_PRICE
	
	#CALL ORIGINAL
	super._ready()
