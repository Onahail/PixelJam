extends Purchase
class_name Module

var repairable = preload("res://LibScripts/repairable.gd").new()
var currentlyRepairing = false

#var repair = ModuleStats.module_data[module_name]["repair_time"]
var health = null
var repair_time = null
var shielded = false
var shieldmod = []

func _ready():
	
	
	$ShieldOverlay.play("shields_on")
	moduleInit()
	$TextureHealthBar.z_index = 2
	
	if get_tree().current_scene.name != "Game":
		$TextureHealthBar.visible = false
	
	
	#shopPos = global_position

func _physics_process(_delta):
	if get_tree().current_scene.name != "Game":
		return

	if mouseOverBody and Input.is_action_just_pressed("Toggle Repair"):
		$RepairTimer.wait_time = repair_time
		$RepairTimer.start()
		repairable.repair_toggled.emit()

	if Input.is_action_just_released("Toggle Repair"):
		repairable.repair_cancelled.emit()
		
	#print(currentlyRepairing)
	if currentlyRepairing == true:
		$RepairProgressBar.value = $RepairTimer.wait_time - $RepairTimer.time_left
	
	var overlapping_bodies = $Area2D.get_overlapping_bodies()
			
	for body in overlapping_bodies:
		body.collided()
		EventBus.apply_explosive_damage.emit()
		repairable.applyDamage(overlapping_bodies.size() * Globals.ENEMY_DAMAGE, self)
			
	$TextureHealthBar.value = repairable.currentHP

func ActivateShields(caller = null):
	shielded = true
	$ShieldOverlay.visible = true
	shieldmod.append(caller)
	print("activate shield called, array size is now ",shieldmod.size())
	
func DeactivateShields(caller = null):
	shieldmod.erase(caller)
	#print("deactivate shield called, array size is now ",shieldmod.size())
	shielded = false
	if(shieldmod.size() == 0):
		$ShieldOverlay.visible = false

func _on_area_2d_mouse_exited():
	if currentlyRepairing == true:
		repairable.repair_cancelled.emit()
	super._on_area_2d_mouse_exited()

func _on_repair_completed():
	$Area2D.set_collision_mask_value(4, true)

func _on_hp_depleted():
	$Area2D.set_collision_mask_value(4, false)
	Globals.modulesOnShip[module_name] -= 1
	Globals.calc_collection_rates()
	self.hide()

func _on_repair_timer_timeout():
	Input.set_custom_mouse_cursor(Globals.DEFAULT_CURSOR)
	repairable.repairDamage(health)
	$RepairProgressBar.visible = false
	
func _on_repair_toggled():
	Input.set_custom_mouse_cursor(Globals.REPAIR_CURSOR)
	currentlyRepairing = true
	$RepairProgressBar.visible = true
	
func _on_repair_cancelled():
	Input.set_custom_mouse_cursor(Globals.DEFAULT_CURSOR)
	$RepairTimer.stop()
	$RepairProgressBar.visible = false
	currentlyRepairing = false
	
func moduleInit():
	health = ModuleStats.module_data[module_name]["health"]
	price = ModuleStats.module_data[module_name]["price"]
	repair_time = ModuleStats.module_data[module_name]["repair_time"]
	
	$TextureHealthBar.max_value = health
	$TextureHealthBar.value = health
	repairable.currentHP = health
	repairable.maxHP = health
	$RepairProgressBar.max_value = repair_time
	$RepairProgressBar.value = repair_time
	$RepairProgressBar.visible = false
	repairable.hp_depleted.connect(_on_hp_depleted)
	repairable.repair_toggled.connect(_on_repair_toggled)
	repairable.repair_cancelled.connect(_on_repair_cancelled)
	repairable.repair_completed.connect(_on_repair_completed)
	
	
	
