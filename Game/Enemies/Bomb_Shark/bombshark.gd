extends Enemy


func _ready():
	
	$AnimatedSprite2D.play("swimming")
	enemy_name = "Bombshark"
	super._ready()
	currentHP = int(currentHP * 1.3)
	

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


"""
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
"""


func collided():
	PlayExplosion()
	velocity = stopped * 0
	super.collided()

func PlayExplosion():
	$AnimatedSprite2D.visible = false
	$ExplosionSound.play()
	$ForwardExplosion.visible = true
	$ForwardExplosion.play("explosion")

func _on_forward_explosion_animation_finished():
		if dead == true:
			queue_free()
