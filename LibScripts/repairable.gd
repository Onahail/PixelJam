extends Resource
class_name Repairable
#test thing?
@export var currentHP: int = 100
@export var maxHP: int = 100

signal hp_depleted
signal repair_toggled
signal repair_completed
signal repair_cancelled
	
func applyDamage(damage):
	currentHP -= damage
	if currentHP <= 0:
		hp_depleted.emit()
		currentHP = 0
	
func repairDamage(repairValue):
	currentHP += repairValue
	if currentHP > maxHP:
		currentHP = maxHP
	repair_completed.emit()
