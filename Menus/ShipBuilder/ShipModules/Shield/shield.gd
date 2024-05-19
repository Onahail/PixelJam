extends Module

var shield_mods_checked = false
var surrounding_modules = []
var shield_hp = ModuleStats.module_data["Shield"]["misc"]["shield_hp"]
var recharge_rate = ModuleStats.module_data["Shield"]["misc"]["recharge_rate"]
var recharge_delay = ModuleStats.module_data["Shield"]["misc"]["recharge_delay"]
var charging = false

func _ready():
	
	#CHANGE VALUES
	module_name = "Shield"
	$ShieldsActive.play("shields_active")
	$ChargeDelay.wait_time = recharge_delay
	$ChargeDelay.paused = true
	$ChargeDelay.start()
	$Recharger.wait_time = recharge_rate
	$Recharger.paused = true
	$Recharger.start()
	#CALL ORIGINAL
	super._ready()

func _process(delta):

	if get_tree().current_scene.name == "Game":
		if(surrounding_modules.size() == 0):
			$ShieldsActive.visible = true
			CheckShieldableModules()
			for module in surrounding_modules:
				if module != null:
					module.ActivateShields(self)
		if(shield_hp <= 0):
			$ShieldsActive.visible = false
			for module in surrounding_modules:
				if module != null:
					module.DeactivateShields(self)
		elif(shield_hp < ModuleStats.module_data["Shield"]["misc"]["recharge_delay"]):
			$ShieldsActive.visible = true
			$ChargeDelay.paused = false
		if(charging):
			$Recharger.paused = false
		else:
			$Recharger.paused = true
			$Recharger.start()
		"""
		if Input.is_action_pressed("Activate Shields"):
			$ShieldsActive.visible = true
			Globals.SHIELD_POWER -= Globals.SHIELD_DRAIN * delta
			for module in surrounding_modules:
				if module != null:
					if Globals.SHIELD_POWER > 0:
						module.ActivateShields(self)
		if Input.is_action_just_released("Activate Shields"):
			$ShieldsActive.visible = false
			for module in surrounding_modules:
				if module != null:
					module.DeactivateShields(self)
							
		if !Input.is_action_pressed("Activate Shields"):
			if Globals.SHIELD_POWER < Globals.MAX_SHIELD_POWER:
				Globals.SHIELD_POWER += Globals.SHIELD_RECHARGE_RATE * delta

		if Globals.SHIELD_POWER <= 0:
			Globals.SHIELD_POWER = 0
			
	
	
	if surrounding_modules.size() == 0:
		CheckShieldableModules()
	
"""
	super._process(delta)

func _on_hp_depleted():
	#TODO Shield Destroyed
	super._on_hp_depleted()
	pass

func CheckShieldableModules():
	print("CheckShieldableModules called")
	print(global_position)

	var shield_params = PhysicsPointQueryParameters2D.new()
	
	var point = self.global_position
	
	#OFFSETS
	var top = Vector2(0, -64)
	var bottom = Vector2(0, 64)
	var top_left = Vector2(-76, -32)
	var top_right = Vector2(76, -32)
	var bottom_left = Vector2(-76, 32)
	var bottom_right = Vector2(76,32)

	var offsets = [top, bottom, top_left, top_right, bottom_left, bottom_right]
	var results = []
	var area = get_world_2d().direct_space_state

	
	for offset in offsets:
			var check_pos = point + offset
			shield_params.position = check_pos
			shield_params.collide_with_areas = true
			shield_params.collide_with_bodies = true
			
			var shield_check = area.intersect_point(shield_params)
			results.append({
						"check": shield_check,
						"offset": offset
					})
	for result in results:
		if result["check"].size() > 0:
			if(result["check"][0]["collider"].get_parent().module_name == "Hull"):
				surrounding_modules.append(result["check"][0]["collider"].get_parent())
			else:
				surrounding_modules.append(result["check"][0]["collider"].get_parent().get_parent().get_parent())
				
			
			
	print("Found all shieldable modules: ", surrounding_modules)


func _on_charge_delay_timeout():
	print("Shield Charge Started")
	if(shield_hp == 0):
		shield_hp = ModuleStats.module_data["Shield"]["misc"]["shield_hp"]
		$ChargeDelay.paused = true
		$ChargeDelay.start()
		for module in surrounding_modules:
			if module != null:
				module.ActivateShields(self)
	else:
		charging = true
		$ChargeDelay.paused = true
		$ChargeDelay.start()


func _on_recharger_timeout():
	shield_hp += 1
	print("Shield Charged to ",shield_hp," hp of ",ModuleStats.module_data["Shield"]["misc"]["shield_hp"])
	if(shield_hp >= ModuleStats.module_data["Shield"]["misc"]["shield_hp"]):
		shield_hp == ModuleStats.module_data["Shield"]["misc"]["shield_hp"]
		$Recharger.paused = true
		$Recharger.start()
		charging = false
