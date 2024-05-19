extends Node2D

# TODO: Dynamic loading of assets
const PROPELLER = preload("res://Menus/ShipBuilder/ShipModules/Propeller/propeller.tscn")
const GUN = preload("res://Menus/ShipBuilder/ShipModules/Gun/gun_deck.tscn")
const STORAGE = preload("res://Menus/ShipBuilder/ShipModules/Storage/storage.tscn")
const SCOOP = preload("res://Menus/ShipBuilder/ShipModules/Scoop/scoop.tscn")
const BRIDGE = preload("res://Menus/ShipBuilder/ShipModules/Bridge/bridge.tscn")
const SHIELD = preload("res://Menus/ShipBuilder/ShipModules/Shield/shield.tscn")
const HULL = preload("res://Menus/ShipBuilder/ShipModules/BaseTile/base_tile.tscn")
const SHIP = preload("res://Menus/ShipBuilder/Ships/starter_ship.tscn")
const MUSIC = preload("res://Music/078 Heartbound OST Gearworks.mp3")

# TODO: Dynamic selection of positions
var modules = []

@onready var inventory_positions = {
		PROPELLER: $UI/Shop/PropellerMarker.global_position,
		GUN: $UI/Shop/GunMarker.global_position,
		STORAGE: $UI/Shop/StorageMarker.global_position,
		SCOOP: $UI/Shop/ScoopMarker.global_position,
		BRIDGE: $UI/Shop/BridgeMarker.global_position,
		SHIELD: $UI/Shop/ShieldMarker.global_position,
		SHIP: $UI/Shop/ShipSpawnPoint.global_position,
		HULL: $UI/Shop/HullMarker.global_position
	}

signal inventory_spawned

func _ready():
	MenuMusic.stop()
	Globals.INITIAL_LOAD = true
	#Dynamically build module list and load scenes
	for module in ModuleStats.module_data:
		modules.append(str(module))
		# TODO: Dynamically load modules from file instead of preload manually
		#load(ModuleStats.module_data[str(module)]["assets"]["scene"])

	EventBus.item_sold.connect(_on_item_sold)
	EventBus.item_purchased.connect(_on_item_purchased)
	EventBus.item_too_expensive.connect(_on_item_too_expensive)
	EventBus.too_many_modules.connect(_on_too_many_modules)
	EventBus.module_stacked.connect(_on_module_stacked)
	EventBus.invalid_module_position.connect(_on_invalid_module_position)
	EventBus.hull_placed_above_or_below_scoop.connect(_on_hull_placed_by_scoop)
	EventBus.hull_placed_behind_propeller.connect(_on_hull_placed_behind_propeller)
	EventBus.hull_placed_right_of_bridge.connect(_on_hull_placed_right_of_bridge)
	$UI/Information/ErrorMessage.visible = false
	SpawnInventory(inventory_positions)
	SetPriceLabels()
	
	$PlayerShip.load_ship()
	

	
func _process(_delta):
	
	$UI/Information/Currency.text = str("Available Money:\n $", Globals.PLAYER_CURRENCY)
	var shipinfo = ""
	for module in Globals.modulesOnShip:
		shipinfo = str(shipinfo, module, ": ", Globals.modulesOnShip[module],"/",ModuleStats.module_data[module]["max_allowable"], "\n")
	$UI/Information/ShipPartNumbers.text = shipinfo
	ModuleStats.module_data["Hull"]["price"] = ModuleStats.module_data["Hull"]["base_price"] + pow(2,(Globals.modulesOnShip["Hull"] - 5))
	$UI/Shop/ShopPrices/HullCost.text = str("$",int(ModuleStats.module_data["Hull"]["price"]))
	
func _on_hull_placed_right_of_bridge():
	print("Hull bridge function")
	DisplayErrorMessage()
	$UI/Information/ErrorMessage.text = str("Hull can not be placed right of bridge.")
	pass

func _on_invalid_module_position(module):
	match module:
		"Propeller":
			DisplayErrorMessage()
			$UI/Information/ErrorMessage.text = str(module, " can only be placed on the back of the ship.")
		"Scoop":
			DisplayErrorMessage()
			$UI/Information/ErrorMessage.text = str(module, " can only be placed on the top or the bottom of the ship.")
		"Hull":
			DisplayErrorMessage()
			$UI/Information/ErrorMessage.text = str(module, " can only be placed next to a pre-existing hull.")

func _on_item_sold(module):
	$SoldModule.play()
	Globals.modulesOnShip[module] -= 1
	
func _on_item_too_expensive():
		DisplayErrorMessage()
		$UI/Information/ErrorMessage.text = str("Not enough money to purchase that.")


func _on_item_purchased(module):
	Globals.modulesOnShip[module] += 1
	
func _on_too_many_modules(module):
	DisplayErrorMessage()
	$UI/Information/ErrorMessage.text = str("Exceeded maximum allowance of the ", module, " module.")

	
func _on_module_stacked(module):
	DisplayErrorMessage()
	$UI/Information/ErrorMessage.text = str("Unable to place ", module, " on top of another module.")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")
	$PlayerShip.save_ship()
	

func _on_timer_timeout():
	$UI/Information/ErrorMessage.visible = false


func _on_hull_placed_by_scoop():
	print("Hull scoop function")
	DisplayErrorMessage()
	$UI/Information/ErrorMessage.text = str("Hull can not be placed directly above or below a scoop.")

func _on_hull_placed_behind_propeller():
	print("Hull propeller function")
	DisplayErrorMessage()
	$UI/Information/ErrorMessage.text = str("Hull can not be placed behind propellers.")

func DisplayErrorMessage():
	$UI/Information/ErrorMessage.visible = true
	$Timer.start()
	
func SetPriceLabels():
	for module_name in Globals.modulesOnShip:
		$UI/Shop/ShopPrices.get_node(module_name + "Cost").text = str("$",ModuleStats.module_data[module_name]["price"])

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
		"Hull":
			SpawnItem(HULL, inventory_positions[HULL])


func _on_shop_zone_mouse_entered():
	Globals.MOUSE_IN_SHOP = true


func _on_shop_zone_mouse_exited():
	Globals.MOUSE_IN_SHOP = false

