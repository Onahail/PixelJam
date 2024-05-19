extends CharacterBody2D
class_name Enemy

@onready var currentHP = Globals.ENEMY_HEALTH


var normal_speed = Globals.SPEED
var left = Vector2(-1, 0)
var down = Vector2(-1, 1)
var up = Vector2(-1, -1)
var stopped = Vector2(0, 0)
var damaged = false
var dead = false
var collided_with_ship = false
var rand_collision = 9
var rand_num = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	rand_num = int(randf_range(0,Globals.HULLS.size()))

func _physics_process(_delta):
	if Input.is_action_pressed("leftclick") and Globals.MOUSE_ON_ENEMY:
		Input.set_custom_mouse_cursor(Globals.CROSSHAIR_CURSOR)
	if Input.is_action_just_released("leftclick") and Globals.MOUSE_ON_ENEMY:
		Input.set_custom_mouse_cursor(Globals.DEFAULT_CURSOR)
	
	move_and_slide()


func collided():
	collided_with_ship = true
	self.set_collision_layer_value(4, false)
	dead = true

func take_damage(damage):
	if $AnimatedSprite2D.animation == "swimming":
		$AnimatedSprite2D.stop()
	currentHP -= damage
	if currentHP <= 0:
		dead = true
		$AnimatedSprite2D.play("death")
		self.set_collision_layer_value(4, false)
	else:
		damaged = true
		velocity = left * normal_speed
		$AnimatedSprite2D.play("damaged")	


func _on_mouse_entered():
	#print("Mouse Entered")
	Globals.MOUSE_ON_ENEMY = true
	Input.set_custom_mouse_cursor(Globals.CROSSHAIR_CURSOR)


func _on_mouse_exited():
	Globals.MOUSE_ON_ENEMY = false
	Input.set_custom_mouse_cursor(Globals.DEFAULT_CURSOR)

