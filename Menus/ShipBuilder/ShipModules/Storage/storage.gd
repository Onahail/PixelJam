extends Module

var animation = "fill_stage_1"

func _ready():
	
	
	health = Globals.STORAGE_HEALTH
	price = Globals.STORAGE_PRICE
	
	$AnimatedSprite2D.play(animation)
	
	#CALL ORIGINAL
	super._ready()
	

func _on_hp_depleted():
	$AnimatedSprite2D.stop()

func _on_timer_timeout():
	super._on_timer_timeout()
	$AnimatedSprite2D.play(animation)
