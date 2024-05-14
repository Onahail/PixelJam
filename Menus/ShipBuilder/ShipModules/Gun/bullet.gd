extends Area2D

var travelled_distance = 0

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += direction * Globals.BULLET_SPEED * delta
	
	travelled_distance += Globals.BULLET_SPEED * delta
	if travelled_distance > Globals.BULLET_RANGE:
		queue_free()
		

func _on_body_entered(body):
	queue_free()
	body.take_damage(Globals.BULLET_DAMAGE)
	

