extends Module
class_name Gun

@onready var gunBarrel = $GunBarrel

func _ready():
	
	#CHANGE VALUES
	module_name = "Gun"
	repairable.repair_completed.connect(gunBarrel._on_repair_completed)
	repairable.hp_depleted.connect(gunBarrel._on_hp_depleted)
	repairable.repair_toggled.connect(gunBarrel._on_repair_toggled)
	repairable.repair_cancelled.connect(gunBarrel._on_repair_cancelled)
	
	#CALL ORIGINAL
	super._ready()


func _on_hp_depleted():
	#TODO Scoop Destroyed
	super._on_hp_depleted()
	pass

