extends Module

var animation = "bridge_anim"

func _ready():
	
	#CHANGE VALUES
	module_name = "Bridge"
	$AnimatedSprite2D.play(animation)
	
	#CALL ORIGINAL
	super._ready()
	
func _on_hp_depleted():
	#TODO Bridge Destroyed
	print("Bridge Destroyed")
	super._on_hp_depleted()
	Globals.GameLoss()
	pass
