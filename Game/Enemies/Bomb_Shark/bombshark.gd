extends Enemy


func _ready():
	
	$AnimatedSprite2D.play("swimming")
	super._ready()
	

func _physics_process(delta):
	
	if not dead:
		if Globals.HULLS.size() >= 0:
			if Globals.HULLS[rand_num] == null:
				rand_num = int(randf_range(0,Globals.HULLS.size()))
			if Globals.HULLS[rand_num] != null:
				velocity = global_position.direction_to(Globals.HULLS[rand_num].global_position) * normal_speed
				look_at(Globals.HULLS[rand_num].global_position)
			else:
				velocity = global_position.direction_to(left) * normal_speed
		else:
			velocity = global_position.direction_to(left) * normal_speed
		
	if not damaged:
		$AnimatedSprite2D.play("swimming")
		
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
	$ExplosionSound.play()
	explosion.visible = true
	explosion.play("explosion")


func _on_explosion_animation_animation_finished():
	if dead == true:
		queue_free()


func _on_animated_sprite_2d_animation_finished():
	if damaged == true:
		damaged = false
	pass # Replace with function body.
