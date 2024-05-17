extends CharacterBody2D

@onready var currentHP = Globals.ENEMY_HEALTH
var dart_speed = Globals.SPEED * 2
var normal_speed = Globals.SPEED
var darting = false
var left = Vector2(-1, 0)
var down = Vector2(-1, 1)
var up = Vector2(-1, -1)
var random_directions = [left, left, down, up]
var rand_num = 0
var damaged = false
var dead = false
var collided_with_ship = false
var rand_collision = 9

#TODO Set random collision layer per enemy so they only hit specific modules.


func _physics_process(_delta):
	if Input.is_action_pressed("leftclick") and Globals.MOUSE_ON_ENEMY:
		Input.set_custom_mouse_cursor(Globals.CROSSHAIR_CURSOR)
	if Input.is_action_just_released("leftclick") and Globals.MOUSE_ON_ENEMY:
		Input.set_custom_mouse_cursor(Globals.DEFAULT_CURSOR)
	
	
	if collided_with_ship == true:
		velocity = left * 100
	elif not damaged:
		if darting:
			if rand_num == 4 and self.global_position.x > Globals.VIEWPORT_CENTER.x:
				velocity = global_position.direction_to(Globals.VIEWPORT_CENTER) * dart_speed
			elif rand_num == 4 and self.global_position.x < Globals.VIEWPORT_CENTER.x:
				velocity = random_directions[0] * dart_speed
			else: 
				velocity = random_directions[rand_num] * dart_speed
			$AnimatedSprite2D.play("movement")
		else:
			velocity = left * normal_speed
			if not $AnimatedSprite2D.is_playing():
				$AnimatedSprite2D.play("idle")
	move_and_slide()

func take_damage(damage):
	if dead == true:
		return
	currentHP -= damage
	damaged = true
	velocity = left * normal_speed
	$AnimatedSprite2D.play("damaged")
	if currentHP <= 0:
		dead = true
		$AnimatedSprite2D.play("death")

func collided():
	collided_with_ship = true
	$AnimatedSprite2D.play("death")
	self.set_collision_layer_value(4, false)
	dead = true

func _on_animated_sprite_2d_animation_finished():
	if damaged == true:
		damaged = false
	if darting == true:
		rand_num = int(randf_range(0,5))
		dart_speed = int(randf_range(Globals.SPEED * 2, Globals.SPEED * 3))
		darting = false
	elif darting == false:
		if $Timer.time_left <= 0:
			$AnimatedSprite2D.play("idle")
			$Timer.wait_time = randf_range(0.2, 2)
			$Timer.start()
	if dead == true:
		queue_free()


func _on_timer_timeout():
			darting = true


func _on_mouse_entered():
	Globals.MOUSE_ON_ENEMY = true


func _on_mouse_exited():
	Globals.MOUSE_ON_ENEMY = false
	Input.set_custom_mouse_cursor(Globals.DEFAULT_CURSOR)
