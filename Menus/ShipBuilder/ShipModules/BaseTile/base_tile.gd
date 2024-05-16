extends Module


func _ready():
	$AnimatedSprite2D.play("base_tile_animation")
	module_name = "Hull"

func  _process(_delta):
	pass
	#if Globals.is_dragging:
	#	modulate = Color(Color.LAWN_GREEN, 0.7)
	#else:
	#	modulate = Color(1,1,1,1)
