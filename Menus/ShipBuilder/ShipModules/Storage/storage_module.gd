extends "res://LibScripts/draggable_object.gd"

var repairable = preload("res://LibScripts/repairable.gd").new()
var currentlyRepairing = true
var mouseOverBody = true

func _ready():
	
	repairable.currentHP = Globals.STORAGE_HEALTH
	repairable.hp_depleted.connect(_on_hp_depleted)
	repairable.repair_toggled.connect(_on_repair_toggled)
	
	$AnimatedSprite2D.play("fill_stage_1")
	
	$RepairTimer.visible = false
	
	if get_tree().current_scene.name == "ShipBuilder":
		$TextureHealthBar.visible = false
		initialPos = global_position
		return
		
	$TextureHealthBar.max_value = Globals.STORAGE_HEALTH
	$TextureHealthBar.value = Globals.STORAGE_HEALTH
	
	repairable.currentHP = Globals.STORAGE_HEALTH
	repairable.maxHP = Globals.STORAGE_HEALTH	
	

	$RepairTimer.max_value = Globals.REPAIR_TIME
	$RepairTimer.value = Globals.REPAIR_TIME

func _physics_process(delta):
	if get_tree().current_scene.name != "Game":
		return

	if mouseOverBody and Input.is_action_just_pressed("Toggle Repair"):
		$Timer.wait_time = Globals.REPAIR_TIME
		$Timer.start()
		repairable.beginRepair()

	if Input.is_action_just_released("Toggle Repair"):
		repairCancelled()
		
	#print(currentlyRepairing)
	if currentlyRepairing == true:
		$RepairTimer.value = $Timer.wait_time - $Timer.time_left
		
	var overlapping_enemies = $Area2D.get_overlapping_bodies()
	if overlapping_enemies.size() > 0:
		repairable.applyDamage(overlapping_enemies.size() * Globals.ENEMY_DAMAGE)
		for enemy in overlapping_enemies:
			enemy.queue_free()
			
	$TextureHealthBar.value = repairable.currentHP

func _on_area_2d_mouse_entered():
	mouseOverBody = true
	if get_tree().current_scene.name != "ShipBuilder":
		return
	if not Globals.is_dragging:
		draggable = true
		scale = Vector2(1.05,1.05)
		
func _on_area_2d_mouse_exited():
	mouseOverBody = false
	if currentlyRepairing == true:
		repairCancelled()
	if get_tree().current_scene.name != "ShipBuilder":
		return
	if not Globals.is_dragging:
		draggable = false
		scale = Vector2(1,1)

func _on_area_2d_body_entered(body):
	if body.is_in_group('droppable'):
		drop_points.append(body)
		is_inside_droppable = true
		body.modulate = Color(Color.GREEN, 0.5)
		body_ref = body


func _on_area_2d_body_exited(body):
	if body.is_in_group('droppable'):
		drop_points.erase(body)
		if drop_points.size() == 0:
			is_inside_droppable = false
		body.modulate = Color(1,1,1,1)


func _on_hp_depleted():
	$AnimatedSprite2D.stop()


func _on_timer_timeout():
	repairable.repairDamage(Globals.STORAGE_HEALTH)
	$Timer.stop()
	$RepairTimer.visible = false
	$AnimatedSprite2D.play("fill_stage_1")
	
func _on_repair_toggled():
	currentlyRepairing = true
	$RepairTimer.visible = true
	
func repairCancelled():
	$Timer.stop()
	$RepairTimer.visible = false
	currentlyRepairing = false
