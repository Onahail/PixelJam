extends Module


func _ready():
	
	#CHANGE VALUES
	module_name = "Shield"
	
	#CALL ORIGINAL
	super._ready()

func _on_hp_depleted():
	#TODO Shield Destroyed
	super._on_hp_depleted()
	pass
