extends CharacterBody2D

var travelled_distance = 0
var direction = Vector2.ZERO

func _ready():
	$Projectile.play("blinking")
	direction = Vector2.RIGHT.rotated(rotation)

func _physics_process(delta):
	
	
	var step = Globals.LAUNCHERFISH_PROJECTILE_VELOCITY * delta
	global_position += direction * step
	
	travelled_distance += step
	if travelled_distance > Globals.LAUNCHERFISH_RANGE:
		queue_free()
	
func collided():
	#print("Collided")
	queue_free()

func take_damge(damage):
	pass
