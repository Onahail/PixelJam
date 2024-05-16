extends CharacterBody2D

@onready var currentHP = Globals.ENEMY_HEALTH

func _physics_process(_delta):
	var direction = global_position.direction_to(Globals.VIEWPORT_CENTER)
	velocity = direction * Globals.ENEMY_MOVE_SPEED
	move_and_slide()

func take_damage(damage):
	currentHP -= damage
	if currentHP == 0:
		queue_free()
		Globals.RESOURCES_COLLECTED += 10
		print("Enemy defeated")
