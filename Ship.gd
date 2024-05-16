extends Node2D

var tile = preload("res://Menus/ShipBuilder/ShipModules/BaseTile/base_tile.tscn")

func _ready():
	var spawn_point = $Marker2D.global_position
	var new_tile = tile.instantiate()
	new_tile.global_position = spawn_point
	$".".add_child(new_tile)
