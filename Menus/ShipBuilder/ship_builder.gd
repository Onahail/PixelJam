extends Node2D

#var draggable_bodies = [$GunModule]

func _ready():
	
	$NotEnoughMoney.visible = false

func _process(delta):
	if Globals.purchased_module == true:
		modulePurchased()
	
func modulePurchased():
	print("Module purchased")
	Globals.purchased_module = false
	#Globals.PLAYER_CURRENCY -= price

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")

