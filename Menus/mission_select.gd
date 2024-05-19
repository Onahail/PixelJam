extends Node2D

var SCALE_START = Globals.DIFF_SCALE_START
var SCALE_END = Globals.DIFF_SCALE_END

func _ready():
	$PlayerShip.load_ship()
	$PlayerShip.scale = Vector2(.6,.6)
	if(Globals.DEPTH >= %DepthSlider.min_value and Globals.DEPTH <= %DepthSlider.max_value):
		var scalesize = %DepthSlider.max_value - %DepthSlider.min_value
		var scalepoint = %DepthSlider.value - %DepthSlider.min_value
		var difficulty = (float(scalepoint / scalesize) * (SCALE_END - SCALE_START)) + SCALE_START
		%DepthSlider.value = Globals.DEPTH
		Globals.DIFFICULTY = difficulty
	else:
		Globals.DIFFICULTY = SCALE_START
		Globals.DEPTH = %DepthSlider.min_value
func _process(_delta):
	%DepthDisplay.text = str("Depth:\n", %DepthSlider.value)
	
	
func _on_back_pressed():
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")

func _on_mission_start_pressed():
	get_tree().change_scene_to_file("res://Game/game.tscn")

func _on_v_slider_drag_ended(value_changed):
	var scalesize = %DepthSlider.max_value - %DepthSlider.min_value
	var scalepoint = %DepthSlider.value - %DepthSlider.min_value
	var difficulty = (float(scalepoint / scalesize) * (SCALE_END - SCALE_START)) + SCALE_START
	Globals.DEPTH = %DepthSlider.value
	Globals.DIFFICULTY = difficulty
