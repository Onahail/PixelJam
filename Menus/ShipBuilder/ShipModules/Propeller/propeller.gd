extends Module

var animation = "propeller_spin"

func _ready():
	
	#CHANGE VALUES
	module_name = "Propeller"
	$AnimatedSprite2D.play(animation)
	
	#CALL ORIGINAL
	super._ready()


func _on_hp_depleted():
	$AnimatedSprite2D.stop()
	
func _on_timer_timeout():
	super._on_timer_timeout()
	$AnimatedSprite2D.play(animation)
	
