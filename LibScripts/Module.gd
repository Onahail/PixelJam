extends Purchase
class_name Module

var repair_sounds = preload("res://Sounds/construction-soundscape-with-reverb-32795.mp3")
var currentlyRepairing = false

#var repair = ModuleStats.module_data[module_name]["repair_time"]
var health = null
var repair_time = null
var shielded = false
var shieldmod = []

@export var currentHP: int = 100
@export var maxHP: int = 100

signal hp_depleted
signal repair_toggled
signal repair_completed
signal repair_cancelled

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
		repair_toggled.emit()

	if Input.is_action_just_released("Toggle Repair"):
		repair_cancelled.emit()
		
	#print(currentlyRepairing)
	if currentlyRepairing == true:
		$RepairProgressBar.value = $RepairTimer.wait_time - $RepairTimer.time_left
	
	var overlapping_bodies = $Area2D.get_overlapping_bodies()
			
	for body in overlapping_bodies:
		#print(self.get_children())
		body.collided()
		EventBus.apply_explosive_damage.emit()
		applyDamage(overlapping_bodies.size() * Globals.ENEMY_DAMAGE, self)
			
	$TextureHealthBar.value = currentHP

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
		repair_cancelled.emit()
	super._on_area_2d_mouse_exited()

func _on_repair_completed():
	$Area2D.set_collision_mask_value(4, true)

func _on_hp_depleted():
	$Area2D.set_collision_mask_value(4, false)
	Globals.modulesOnShip[module_name] -= 1
	Globals.calc_collection_rates()
	self.queue_free()

func _on_repair_timer_timeout():
	MenuMusic.stop()
	Input.set_custom_mouse_cursor(Globals.DEFAULT_CURSOR)
	repairDamage(health)
	$RepairProgressBar.visible = false
	
func _on_repair_toggled():
	Input.set_custom_mouse_cursor(Globals.REPAIR_CURSOR)
	MenuMusic.stream = repair_sounds
	MenuMusic.play()
	MenuMusic.volume_db = 20
	currentlyRepairing = true
	$RepairProgressBar.visible = true
	
func _on_repair_cancelled():
	MenuMusic.stop()
	Input.set_custom_mouse_cursor(Globals.DEFAULT_CURSOR)
	$RepairTimer.stop()
	$RepairProgressBar.visible = false
	currentlyRepairing = false
	
func moduleInit():
	health = ModuleStats.module_data[module_name]["health"]
	price = ModuleStats.module_data[module_name]["price"]
	repair_time = Globals.REPAIR_TIME
	#repair_time = ModuleStats.module_data[module_name]["repair_time"]
	
	$TextureHealthBar.max_value = health
	$TextureHealthBar.value = health
	currentHP = health
	maxHP = health
	$RepairProgressBar.max_value = repair_time
	$RepairProgressBar.value = repair_time
	$RepairProgressBar.visible = false
	hp_depleted.connect(_on_hp_depleted)
	repair_toggled.connect(_on_repair_toggled)
	repair_cancelled.connect(_on_repair_cancelled)
	repair_completed.connect(_on_repair_completed)
	

	
func applyDamage(damage, module, ishullcalling:bool = false):
	#If the damage is to be applied to a hull, check if a module is attached first
	if(module is HullTile):
		#print("Shield Count is ",module.shieldmod.size())
		if(module.shieldmod.size() > 0):
			#print("Shield taking ",damage," damage")
			for shield in module.shieldmod:
				shield.shield_hp -= damage
				shield.get_node("ChargeDelay").start()
				shield.get_node("ChargeDelay").paused = false
				shield.charging = false
				#print("Shield now has",shield.shield_hp," hp")
				if(shield.shield_hp <= 0):
					damage = 0 - shield.shield_hp
					shield.shield_hp = 0
				else:
					return 0
				break
		var modfound = false
		for mod in module.get_children():
			if (mod is Module):
				modfound = true
				#If the module is already dead, damage hull, else damage module
				if(mod.currentHP == 0):
					currentHP -= damage
					if currentHP <= 0:
						hp_depleted.emit()
						currentHP = 0
				else:
					#If module still has HP, apply damage to the module and check for overkill
					#print("Current HP: ", mod.currentHP, ". Damage Taken: ", damage, ". Module: ", mod)
					var overkill = mod.applyDamage(damage, mod, true)
					#If enemies did more damage to the module than it has HP, apply that damage to the hull
					if(overkill > 0):
						currentHP -= overkill
						if currentHP <= 0:
							hp_depleted.emit()
							currentHP = 0
		#If no module is attached, apply damage to hull
		if(!modfound): 
			currentHP -= damage
			if currentHP <= 0:
				hp_depleted.emit()
				currentHP = 0
	#If we are not a hull and the hull asked for damage, damage me
	elif(ishullcalling):
		currentHP -= damage
		#Trigger Module Death
		if currentHP <= 0:
			#print("Current HP less than or equals 0")
			hp_depleted.emit()
			var overkill = 0 - currentHP
			currentHP = 0
			#Return value of overkill damage
			return overkill
	#No overkill damage is detected
	return 0
	
func repairDamage(repairValue):
	#print("Repair Value: ", repairValue)
	currentHP += repairValue
	if currentHP > maxHP:
		currentHP = maxHP
	repair_completed.emit()
	
