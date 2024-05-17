extends Module

var x = null
var y = null

func _ready():
	module_name = "Hull"
	super._ready()

func _on_hp_depleted():
	#TODO Hull Destroyed
	super._on_hp_depleted()
	pass
