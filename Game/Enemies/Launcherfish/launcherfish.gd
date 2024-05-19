extends Enemy

const PROJECTILE = preload("res://Game/Enemies/Launcherfish/launcherfish_projectile.tscn")
var initial_shot = false
var in_firing_range = false

# Movement parameters
var amplitude = 20  # How far the enemy moves up and down
var frequency = 2  # How fast the enemy moves up and down
var original_position = Vector2()  # To store the initial position
var original_position_set = false

func _ready():
	$ShootTimer.wait_time = Globals.LAUNCHERFISH_FIRE_RATE

func _physics_process(delta):
	if not dead and not in_firing_range:
		velocity = global_position.direction_to(Globals.VIEWPORT_CENTER) * normal_speed
	
	if $Range.get_overlapping_areas().size() > 0:
		if original_position_set == false:
			original_position = position
			original_position = true
		in_firing_range = true
		velocity = stopped * 0
		if $ShootTimer.time_left == 0:
			if initial_shot == false:
				shoot()
				initial_shot = true
				$ShootTimer.start()
				
	if original_position_set == true:
		print(position.y)
		position.y = original_position.y + amplitude * sin(frequency * Time.get_ticks_msec() / 1000.0)
	
	super._physics_process(delta)

func _on_shoot_timer_timeout():
	shoot()
	pass # Replace with function body.


func shoot():
	var new_projectile = PROJECTILE.instantiate()
	new_projectile.global_position = $FirePoint.global_position
	new_projectile.global_rotation = $FirePoint.global_rotation
	$FirePoint.add_child(new_projectile)
