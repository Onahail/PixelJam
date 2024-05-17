extends Node

#SAVE FILES
var cash = 0
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
var SPAWN_RATE = 1
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

#DEBUG
var COUNT = 0

func calc_collection_rates():
	Globals.MAX_RESOURCES = (Globals.modulesOnShip["Storage"] + 1) * ModuleStats.module_data["Storage"]["misc"]["capacity"]
	Globals.COLLECTION_RATE = Globals.modulesOnShip["Propeller"] * Globals.modulesOnShip["Scoop"] * ModuleStats.module_data["Scoop"]["misc"]["collection_rate"]
