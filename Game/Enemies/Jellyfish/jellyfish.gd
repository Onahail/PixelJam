extends Enemy



var darting = false
var dart_speed = Globals.SPEED * 2
var random_directions = [left, left, down, up]
var rand_num_jelly = 0

func _ready():
	enemy_name = "Jellyfish"

func _physics_process(delta):
	
	if collided_with_ship == true:
		velocity = left * 100
	elif not damaged:
		if darting:
			if rand_num_jelly == 4 and self.global_position.x > Globals.VIEWPORT_CENTER.x:
				velocity = global_position.direction_to(Globals.VIEWPORT_CENTER) * dart_speed
			elif rand_num_jelly == 4 and self.global_position.x < Globals.VIEWPORT_CENTER.x:
				velocity = random_directions[0] * dart_speed
			else: 
				velocity = random_directions[rand_num_jelly] * dart_speed
			$AnimatedSprite2D.play("swimming")
		else:
			velocity = left * normal_speed
			if not $AnimatedSprite2D.is_playing():
				$AnimatedSprite2D.play("idle")
	
	super._physics_process(delta)

func collided():
	$AnimatedSprite2D.play("death")
	$JellyThud.play()
	super.collided()

func _on_animated_sprite_2d_animation_finished():
	if not dead:
		if darting == true:
			rand_num_jelly = int(randf_range(0,5))
			dart_speed = int(randf_range(Globals.SPEED * 2, Globals.SPEED * 3))
			darting = false
		elif darting == false:
			if $Timer.time_left <= 0:
				$AnimatedSprite2D.play("idle")
				$Timer.wait_time = randf_range(0.5, 2)
				$Timer.start()
	super._on_animated_sprite_2d_animation_finished()


func _on_timer_timeout():
	darting = true



