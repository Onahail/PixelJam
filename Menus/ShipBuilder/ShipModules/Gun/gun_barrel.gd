extends Node2D

var disabled = false

func _ready():
	if get_tree().current_scene.name == "ShipBuilder":
		global_rotation = -1.55

func _physics_process(delta):
	if get_tree().current_scene.name != "Game":
		return
	if disabled == false:
		look_at(get_global_mouse_position())
		if Input.is_action_just_pressed("leftclick"):	
			shoot()

func shoot():
	if get_tree().current_scene.name != "Game":
		return
	const BULLET = preload("res://Menus/ShipBuilder/ShipModules/Gun/bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.global_position = $Gun/ShootPoint.global_position
	new_bullet.global_rotation = $Gun/ShootPoint.global_rotation
	$Gun/ShootPoint.add_child(new_bullet)
	
func _on_hp_depleted():
	disabled = true

func _on_repair_toggled():
	pass
	
func _on_repair_completed():
	disabled = false
