extends Resource
class_name Repairable

@export var currentHP: int = 100
@export var maxHP: int = 100

signal hp_depleted
signal repair_toggled
signal repair_completed
signal repair_cancelled
	
func applyDamage(damage, module, ishullcalling:bool = false):
	#If the damage is to be applied to a hull, check if a module is attached first
	if(module.module_name == "Hull"):
		var modfound = false
		for mod in module.get_node("HullTile").get_children():
			if (mod is Module):
				modfound = true
				#If the module is already dead, damage hull, else damage module
				if(mod.repairable.currentHP == 0):
					currentHP -= damage
					if currentHP <= 0:
						hp_depleted.emit()
						currentHP = 0
				else:
					#If module still has HP, apply damage to the module and check for overkill
					#print("Current HP: ", mod.repairable.currentHP, ". Damage Taken: ", damage, ". Module: ", mod)
					var overkill = mod.repairable.applyDamage(damage, mod, true)
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
