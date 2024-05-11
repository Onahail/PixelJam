extends Node2D

var COLLECTION_RATE = 20
var RESOURCES_COLLECTED = 0
var MAX_RESOURCES = 100

signal fullResources

func _ready():
	$ProgressBar.value = RESOURCES_COLLECTED
	$Victory.visible = false

func _physics_process(delta):
	RESOURCES_COLLECTED += COLLECTION_RATE * delta
	$ProgressBar.value = RESOURCES_COLLECTED
	if RESOURCES_COLLECTED >= MAX_RESOURCES:
		$Victory/ResourcesCollected.text = str("You collected ", MAX_RESOURCES, " resources worth ", MAX_RESOURCES,"$.")
		$Victory.visible = true

func _on_return_to_surface_pressed():
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")
