extends Module

func _ready():
	
	#CHANGE VALUES
	module_name = "Storage"
	$AnimatedSprite2D.play("fill_stage_1")
	
	#CALL ORIGINAL
	super._ready()
	
	
func _process(_delta):
	if get_tree().current_scene.name == "Game":
		var storage_percent = float(Globals.RESOURCES_COLLECTED) / Globals.MAX_RESOURCES
		if storage_percent > 0.25 and storage_percent < 0.5:
			$AnimatedSprite2D.play("fill_stage_2")
		elif storage_percent > 0.5 and storage_percent < 0.75:
			$AnimatedSprite2D.play("fill_stage_3")
		elif storage_percent > 0.75:
			$AnimatedSprite2D.play("fill_stage_4")
			
	super._process(_delta)
