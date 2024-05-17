extends Module

var x = null
var y = null

func _ready():
	module_name = "Hull"
	super._ready()
	$TextureHealthBar.z_index = 1

func _on_hp_depleted():
	#TODO Hull Destroyed
	super._on_hp_depleted()
