extends Node

#SAVE FILES
var ship_config = []
var ship_max_width = 10
var ship_max_height = 10
var ship_hull = 1
var ship_gun = 2
var savelocation = "user://savegame.csv"
var backupsavelocation = "user://backupsavegame.csv"
var running = false

var SHIP_PIECES = []

#CURSORS
var REPAIR_CURSOR = preload("res://UI_Elements/Repair_Cursor.png")
var CROSSHAIR_CURSOR = preload("res://UI_Elements/Crosshair_Cursor.png")
var DEFAULT_CURSOR = preload("res://UI_Elements/Default_Cursor.png")

#GAME STATS
var PLAYER_WIN = false
var DEPTH = 100
var DIFFICULTY :float = 0
var DIFF_SCALE_START = 2
var DIFF_SCALE_END = 10
var CURRENCY_SCALE_START = 0.2
var CURRENCY_SCALE_END = 0.6

#COLLECTION
var COLLECTION_RATE = 0
var RESOURCES_COLLECTED = 0
var MAX_RESOURCES = 100
#CURRENCY
var PLAYER_CURRENCY = 100

#PURCHASING
var purchased_module = false
var purchase_price
var insufficient_money = false

#ENEMIES
var ENEMY_MOVE_SPEED = 220
var ENEMY_HEALTH = 5
var SPAWN_RATE : float = 1
var BASE_SPAWN_RATE : float = 6
var ENEMY_DAMAGE = 3
var EXPLOSION_DAMAGE = 1
var MOUSE_ON_ENEMY = false


var LAUNCHERFISH_FIRE_RATE = 1
var LAUNCHERFISH_PROJECTILE_DAMAGE = 2
var LAUNCHERFISH_RANGE = 5000
var LAUNCHERFISH_PROJECTILE_VELOCITY = 1000



#SHIP STATS
var SPEED = 200
var REPAIR_TIME = 2
var MAX_SHIELD_POWER = 100
var SHIELD_POWER = 100
var SHIELD_DRAIN = 0
var SHIELDS_ACTIVE = false
var SHIELD_RECHARGE_RATE = 50

#MISC
var VIEWPORT_CENTER
var is_dragging = false
var MOUSE_IN_SHOP = false
var INITIAL_LOAD = true

#SHIP PARTS
var modulesOnShip = {
	"Propeller" : 0, 
	"Gun" : 0, 
	"Storage": 0, 
	"Scoop": 0, 
	"Bridge": 0, 
	"Shield": 0,
	"Hull": 0
}

var HULLS = []

#DEBUG
var COUNT = 0

func calc_collection_rates():
	SPEED = float(Globals.modulesOnShip["Propeller"] * (8/float(Globals.modulesOnShip["Hull"]))) * ModuleStats.module_data["Propeller"]["misc"]["speed_boost"]
	Globals.MAX_RESOURCES = (Globals.modulesOnShip["Storage"] + 0.4) * ModuleStats.module_data["Storage"]["misc"]["capacity"]
	Globals.COLLECTION_RATE = float(Globals.modulesOnShip["Propeller"] * (8/float(Globals.modulesOnShip["Hull"]))) * Globals.modulesOnShip["Scoop"] * ModuleStats.module_data["Scoop"]["misc"]["collection_rate"]
	SPAWN_RATE = float(BASE_SPAWN_RATE/(float(Globals.modulesOnShip["Propeller"] * (8/float(Globals.modulesOnShip["Hull"]))))/DIFFICULTY)
func GameLoss():
	PLAYER_WIN = false
	print("Game Loss called")
	Input.set_custom_mouse_cursor(Globals.DEFAULT_CURSOR)
	get_tree().change_scene_to_file("res://Game/end_game_screen.tscn")
	
func GameWin():
	PLAYER_WIN = true
	Input.set_custom_mouse_cursor(Globals.DEFAULT_CURSOR)
	get_tree().change_scene_to_file("res://Game/end_game_screen.tscn")
