extends Draggable
class_name Module

var repairable = preload("res://LibScripts/Repairable.gd").new()
var currentlyRepairing = false

@export var module_name = "Default"

#var repair = ModuleStats.module_data[module_name]["repair_time"]
var health = 0
var repair_time = 0

func _ready():
	
	moduleInit()
	
	if get_tree().current_scene.name != "Game":
		$TextureHealthBar.visible = false
	
	
	shopPos = global_position
	
func _physics_process(_delta):
	if get_tree().current_scene.name != "Game":
		return

	if mouseOverBody and Input.is_action_just_pressed("Toggle Repair"):
		$Timer.wait_time = Globals.REPAIR_TIME
		$Timer.start()
		repairable.repair_toggled.emit()

	if Input.is_action_just_released("Toggle Repair"):
		repairable.repair_cancelled.emit()
		
	#print(currentlyRepairing)
	if currentlyRepairing == true:
		$RepairTimer.value = $Timer.wait_time - $Timer.time_left
		
	var overlapping_enemies = $Area2D.get_overlapping_bodies()
	if overlapping_enemies.size() > 0:
		repairable.applyDamage(overlapping_enemies.size() * Globals.ENEMY_DAMAGE)
		for enemy in overlapping_enemies:
			enemy.queue_free()
			
	$TextureHealthBar.value = repairable.currentHP

func _on_area_2d_mouse_exited():
	super._on_area_2d_mouse_exited()
	if currentlyRepairing == true:
		repairable.repair_cancelled.emit()




func _on_hp_depleted():
	#FOR USAGE IF NEEDED
	pass

func _on_timer_timeout():
	repairable.repairDamage(health)
	$Timer.stop()
	$RepairTimer.visible = false
	
func _on_repair_toggled():
	currentlyRepairing = true
	$RepairTimer.visible = true
	
func _on_repair_cancelled():
	$Timer.stop()
	$RepairTimer.visible = false
	currentlyRepairing = false
	
func moduleInit():
	print("ModuleInit called")
	health = ModuleStats.module_data[module_name]["health"]
	price = ModuleStats.module_data[module_name]["price"]
	repair_time = ModuleStats.module_data[module_name]["repair_time"]
	
	$TextureHealthBar.max_value = health
	$TextureHealthBar.value = health
	repairable.currentHP = health
	repairable.maxHP = health	
	$RepairTimer.max_value = repair_time
	$RepairTimer.value = repair_time
	$RepairTimer.visible = false
	repairable.hp_depleted.connect(_on_hp_depleted)
	repairable.repair_toggled.connect(_on_repair_toggled)
	repairable.repair_cancelled.connect(_on_repair_cancelled)
	
	
	
