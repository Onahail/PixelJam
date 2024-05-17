extends Module


func _ready():
	
	#CHANGE VALUES
	module_name = "Bridge"
	
	#CALL ORIGINAL
	super._ready()
	
func _on_hp_depleted():
	#TODO Bridge Destroyed
	print("Bridge Destroyed")
	super._on_hp_depleted()
	Globals.GameLoss()
	pass
