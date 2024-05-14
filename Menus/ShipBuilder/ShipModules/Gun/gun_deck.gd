extends Module

@onready var gunBarrel = $GunBarrel

func _ready():
	
	#CHANGE VALUES
	health = Globals.GUN_TURRET_HEALTH
	price = Globals.GUN_TURRET_PRICE
	
	repairable.repair_completed.connect(gunBarrel._on_repair_completed)
	repairable.hp_depleted.connect(gunBarrel._on_hp_depleted)
	repairable.repair_toggled.connect(gunBarrel._on_repair_toggled)
	repairable.repair_cancelled.connect(gunBarrel._on_repair_cancelled)
	
	#CALL ORIGINAL
	super._ready()
	

