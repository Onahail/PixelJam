extends Enemy

const PROJECTILE = preload("res://Game/Enemies/Launcherfish/launcherfish_projectile.tscn")
var initial_shot = false
var in_firing_range = false
var has_fired = false

# Movement parameters
var amplitude = 20  # How far the enemy moves up and down
var frequency = 2  # How fast the enemy moves up and down
var original_position = Vector2()  # To store the initial position
var original_position_set = false
var movement_direction = Vector2()

func _ready():
	$ShootTimer.wait_time = Globals.LAUNCHERFISH_FIRE_RATE
	enemy_name = "Launcherfish"
	super._ready()
	currentHP = int(currentHP * 1.5)
	

func _physics_process(delta):
	if not dead:
		if not in_firing_range:
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
			$AnimatedSprite2D.play("launching")
			if $AnimatedSprite2D.animation == "launching":
				if $AnimatedSprite2D.frame == 2 and not has_fired:
					has_fired = true
					shoot()
				if $AnimatedSprite2D.frame == 1:
					has_fired = false
		else:
			in_firing_range = false
			if Globals.HULLS.size() == 0:
				print("No more hulls")
				$ShootTimer.stop()
		if not damaged and in_firing_range == false:
			$AnimatedSprite2D.play("swimming")
		
	
	super._physics_process(delta)

func _on_shoot_timer_timeout():
	shoot()
	pass # Replace with function body.


func shoot():
	var new_projectile = PROJECTILE.instantiate()
	new_projectile.global_position = $FirePoint.global_position
	new_projectile.global_rotation = $FirePoint.global_rotation
	$FirePoint.add_child(new_projectile)
