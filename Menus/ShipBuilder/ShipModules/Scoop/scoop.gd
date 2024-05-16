extends Module



func _ready():
	
	#CHANGE VALUES
	module_name = "Scoop"
	
	#CALL ORIGINAL
	super._ready()

func _on_hp_depleted():
	#TODO Scoop Destroyed
	super._on_hp_depleted()
	pass
