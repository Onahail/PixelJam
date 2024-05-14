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

#COLLECTION
var COLLECTION_RATE = 0
var RESOURCES_COLLECTED = 0
var MAX_RESOURCES = 100

#ENEMIES
var ENEMY_MOVE_SPEED = 100
var ENEMY_HEALTH = 5
var SPAWN_SPEED = 2
var ENEMY_DAMAGE = 5

#WEAPONS
var BULLET_DAMAGE = 1
var BULLET_SPEED = 1000
var BULLET_RANGE = 1200

#MISC
var VIEWPORT_CENTER
var is_dragging = false
var REPAIR_TIME = 3

#HEALTH
var GUN_TURRET_HEALTH = 20
var PROPELLER_HEALTH = 20
var STORAGE_HEALTH = 20
