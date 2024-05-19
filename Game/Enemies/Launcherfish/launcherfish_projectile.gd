extends CharacterBody2D

var travelled_distance = 0

func _physics_process(delta):
	look_at(Globals.VIEWPORT_CENTER)
	var direction = Vector2.RIGHT.rotated(rotation)
	var step = Globals.LAUNCHERFISH_PROJECTILE_VELOCITY * delta
	global_position += direction * step
	
	travelled_distance += step
	if travelled_distance > Globals.LAUNCHERFISH_RANGE:
		queue_free()
	
func collided():
	queue_free()

func take_damge(damage):
	pass
