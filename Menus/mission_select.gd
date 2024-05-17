extends Node2D

var SCALE_START = 1
var SCALE_END = 10

func _ready():
	%DepthSlider.value = Globals.DEPTH
	
func _process(_delta):
	%DepthDisplay.text = str("Depth:\n", %DepthSlider.value)
	
	
func _on_back_pressed():
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")

func _on_mission_start_pressed():
	get_tree().change_scene_to_file("res://Game/game.tscn")

func _on_v_slider_drag_ended(value_changed):
	Globals.DEPTH = %DepthSlider.value
