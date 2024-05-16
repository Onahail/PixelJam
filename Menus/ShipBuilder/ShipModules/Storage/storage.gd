extends Module

var animation = "fill_stage_1"


func _ready():
	
	#CHANGE VALUES
	module_name = "Storage"
	$AnimatedSprite2D.play(animation)
	
	#CALL ORIGINAL
	super._ready()
	

func _on_hp_depleted():
	$AnimatedSprite2D.stop()
	#TODO Storage Destroyed
	super._on_hp_depleted()

func _on_repair_timer_timeout():
	$AnimatedSprite2D.play(animation)
	super._on_repair_timer_timeout()
