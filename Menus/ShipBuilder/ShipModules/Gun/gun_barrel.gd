extends Node2D

var disabled = false
var initial_shot = false
const BULLET = preload("res://Menus/ShipBuilder/ShipModules/Gun/bullet.tscn")

func _ready():
	if get_tree().current_scene.name == "ShipBuilder":
		global_rotation = -0.6
	self.z_index = 3
		

func _physics_process(_delta):
	$Timer.wait_time = ModuleStats.module_data["Gun"]["misc"]["fire_rate"]
	if get_tree().current_scene.name != "Game":
		return
	if disabled == false:
		look_at(get_global_mouse_position())
		if Input.is_action_pressed("leftclick"):
			if $Timer.time_left == 0:
				if initial_shot == false:
					shoot()
					initial_shot = true
				$Timer.start()
		if Input.is_action_just_released("leftclick"):
			$Timer.stop()
			initial_shot = false
			
func shoot():
	if get_tree().current_scene.name != "Game" :
		return
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = $Gun/ShootPoint.global_position
	new_bullet.global_rotation = $Gun/ShootPoint.global_rotation
	$Gun/ShootPoint.add_child(new_bullet)
	$GunShot.play()
	
func _on_hp_depleted():
	disabled = true
	$Timer.stop()
	
func _on_repair_cancelled():
	disabled = false

func _on_repair_toggled():
	disabled = true
	
func _on_repair_completed():
	disabled = false


func _on_timer_timeout():
	shoot()
