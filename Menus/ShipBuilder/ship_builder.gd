extends Node2D

# TODO: Dynamic loading of assets
const PROPELLER = preload("res://Menus/ShipBuilder/ShipModules/Propeller/propeller.tscn")
const GUN = preload("res://Menus/ShipBuilder/ShipModules/Gun/gun_deck.tscn")
const STORAGE = preload("res://Menus/ShipBuilder/ShipModules/Storage/storage.tscn")
const SCOOP = preload("res://Menus/ShipBuilder/ShipModules/Scoop/scoop.tscn")
const BRIDGE = preload("res://Menus/ShipBuilder/ShipModules/Bridge/bridge.tscn")
const SHIELD = preload("res://Menus/ShipBuilder/ShipModules/Shield/shield.tscn")
const HULL = preload("res://Menus/ShipBuilder/ShipModules/BaseTile/base_tile.tscn")
# TODO: Dynamic selection of positions
@onready var inventory_positions = {
		PROPELLER: $Shop/PropellerMarker.global_position,
		GUN: $Shop/GunMarker.global_position,
		STORAGE: $Shop/StorageMarker.global_position,
		SCOOP: $Shop/ScoopMarker.global_position,
		BRIDGE: $Shop/BridgeMarker.global_position,
		SHIELD: $Shop/ShieldMarker.global_position,
		HULL: $Shop/HullMarker.global_position
	}

var modules = []

signal inventory_spawned

func _ready():
	#Dynamically build module list and load scenes
	for module in ModuleStats.module_data:
		modules.append(str(module))
		# TODO: Dynamically load modules from file instead of preload manually
		#load(ModuleStats.module_data[str(module)]["assets"]["scene"])

	EventBus.item_sold.connect(_on_item_sold)
	
	$NotEnoughMoney.visible = false
	$Currency.text = str("Available Money:\n", Globals.PLAYER_CURRENCY)
	SpawnInventory(inventory_positions)
	SetPriceLabels()

func _process(_delta):
	$Currency.text = str("Available Money:\n", Globals.PLAYER_CURRENCY)
	#print($Timer.time_left)
	if Globals.insufficient_money == true:
		Globals.insufficient_money = false
		$NotEnoughMoney.visible = true
		$Timer.start()
	
	#var inventory = $Shop/PropellerMarker/Area2D.get_overlapping_areas()
	#print(inventory[0].get_parent().name)

func _on_item_sold():
	$SoldModule.play()

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")

func _on_timer_timeout():
	$NotEnoughMoney.visible = false

func SetPriceLabels():
	for module_name in modules:
		#print(module_name)
		$ShopPrices.get_node(module_name + "Cost").text = str(ModuleStats.module_data[module_name]["price"], "$")


func SpawnInventory(inventory):
	for item in inventory:
		SpawnItem(item, inventory[item])
	
func SpawnItem(item, location):
	var item_instance = item.instantiate()
	call_deferred("add_child", item_instance)
	item_instance.global_position = location

func _on_shop_zone_area_exited(area):
	var item_name = area.get_parent().module_name
	# TODO: Dynamically un fuck whatever this is
	match item_name:
		"Propeller":
			SpawnItem(PROPELLER, inventory_positions[PROPELLER])
		"Gun":
			SpawnItem(GUN, inventory_positions[GUN])
		"Storage":
			SpawnItem(STORAGE, inventory_positions[STORAGE])
		"Scoop":
			SpawnItem(SCOOP, inventory_positions[SCOOP])
		"Bridge":
			SpawnItem(BRIDGE, inventory_positions[BRIDGE])
		"Shield":
			SpawnItem(SHIELD, inventory_positions[SHIELD])
		"HULL":
			SpawnItem(HULL, inventory_positions[HULL])
