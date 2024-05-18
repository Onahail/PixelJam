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

#CURSORS
var REPAIR_CURSOR = preload("res://UI_Elements/Repair_Cursor.png")
var CROSSHAIR_CURSOR = preload("res://UI_Elements/Crosshair_Cursor.png")
var DEFAULT_CURSOR = preload("res://UI_Elements/Default_Cursor.png")

#GAME STATS
var PLAYER_WIN = false
var DEPTH = 100
var DIFFICULTY = 0
var DIFF_SCALE_START = 1
var DIFF_SCALE_END = 10
var CURRENCY_SCALE_START = 0.2
var CURRENCY_SCALE_END = 1

#COLLECTION
var COLLECTION_RATE = 0
var RESOURCES_COLLECTED = 0
var MAX_RESOURCES = 100
#CURRENCY
var PLAYER_CURRENCY = 200

#PURCHASING
var purchased_module = false
var purchase_price
var insufficient_money = false

#ENEMIES
var ENEMY_MOVE_SPEED = 220
var ENEMY_HEALTH = 5
var SPAWN_RATE : float = 1
var BASE_SPAWN_RATE : float = 6
var ENEMY_DAMAGE = 5
var MOUSE_ON_ENEMY = false

#SHIP STATS
var SPEED = 200
var REPAIR_TIME = 3

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
	Globals.MAX_RESOURCES = (Globals.modulesOnShip["Storage"] + 1) * ModuleStats.module_data["Storage"]["misc"]["capacity"]
	Globals.COLLECTION_RATE = Globals.modulesOnShip["Propeller"] * Globals.modulesOnShip["Scoop"] * ModuleStats.module_data["Scoop"]["misc"]["collection_rate"]
	SPAWN_RATE = float((BASE_SPAWN_RATE/modulesOnShip["Propeller"])/DIFFICULTY)
	#print(SPAWN_RATE)
	#print(modulesOnShip["Propeller"])
	SPEED = modulesOnShip["Propeller"] * ModuleStats.module_data["Propeller"]["misc"]["speed_boost"]
	
func GameLoss():
	PLAYER_WIN = false
	print("Game Loss called")
	get_tree().change_scene_to_file("res://Game/end_game_screen.tscn")
	
func GameWin():
	PLAYER_WIN = true
	get_tree().change_scene_to_file("res://Game/end_game_screen.tscn")
