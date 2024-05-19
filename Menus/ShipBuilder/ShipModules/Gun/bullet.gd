extends Area2D

var travelled_distance = 0

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += direction * ModuleStats.module_data["Gun"]["misc"]["velocity"] * delta
	
	travelled_distance += ModuleStats.module_data["Gun"]["misc"]["range"] * delta
	if travelled_distance > ModuleStats.module_data["Gun"]["misc"]["range"]:
		queue_free()
		

func _on_body_entered(body):
	print(body.name)
	queue_free()
	body.take_damage(ModuleStats.module_data["Gun"]["misc"]["damage"])
	

