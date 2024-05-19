extends Enemy

const PROJECTILE = preload("res://Game/Enemies/Launcherfish/launcherfish_projectile.tscn")
var initial_shot = false
var in_firing_range = false

# Movement parameters
var amplitude = 20  # How far the enemy moves up and down
var frequency = 2  # How fast the enemy moves up and down
var original_position = Vector2()  # To store the initial position
var original_position_set = false
var movement_direction = Vector2()

func _ready():
	$ShootTimer.wait_time = Globals.LAUNCHERFISH_FIRE_RATE
	

func _physics_process(delta):
	if not dead and not in_firing_range:
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
	
	if $Range.get_overlapping_areas().size() > 0:
		in_firing_range = true
		velocity = stopped * 0
		if $ShootTimer.time_left == 0:
			if initial_shot == false:
				shoot()
				initial_shot = true
				$ShootTimer.start()
	else:
		in_firing_range = false
		if Globals.HULLS.size() == 0:
			print("No more hulls")
			$ShootTimer.stop()
	if not damaged:
		$AnimatedSprite2D.play("swimming")
	
	
	super._physics_process(delta)

func take_damage(damage):
	currentHP -= damage
	if currentHP <= 0:
		dead = true
		#$AnimatedSprite2D.play("death")
		self.set_collision_layer_value(4, false)
		queue_free()
	else:
		damaged = true
		velocity = left * normal_speed
		#$AnimatedSprite2D.play("damaged")	


func _on_shoot_timer_timeout():
	shoot()
	pass # Replace with function body.


func shoot():
	var new_projectile = PROJECTILE.instantiate()
	new_projectile.global_position = $FirePoint.global_position
	new_projectile.global_rotation = $FirePoint.global_rotation
	$FirePoint.add_child(new_projectile)
