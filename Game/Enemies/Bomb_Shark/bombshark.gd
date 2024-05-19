extends Enemy


func _ready():
	
	$AnimatedSprite2D.play("swimming")
	super._ready()
	

func _physics_process(delta):
	
	if not dead:
		velocity = global_position.direction_to(Globals.VIEWPORT_CENTER) * normal_speed
		
	#if dead == true:
	#	queue_free()
	
	super._physics_process(delta)


func take_damage(damage):
	currentHP -= damage
	if currentHP <= 0:
		dead = true
		PlayExplosion($DeathAnimation)
		self.set_collision_layer_value(4, false)
	else:
		damaged = true
		velocity = left * normal_speed
		$AnimatedSprite2D.play("damaged")



func collided():
	PlayExplosion($ForwardExplosion)
	velocity = stopped * 0
	super.collided()

func PlayExplosion(explosion):
	$AnimatedSprite2D.visible = false
	explosion.visible = true
	explosion.play("explosion")


func _on_explosion_animation_animation_finished():
	if dead == true:
		queue_free()
