extends Node2D

var SCALE_START = Globals.DIFF_SCALE_START
var SCALE_END = Globals.DIFF_SCALE_END
var slider_stylebox = StyleBoxFlat
var grabber_area_stylebox = StyleBoxFlat
var grabber_area_highlight_stylebox = StyleBoxFlat

func _ready():
	$LaunchSign.play("sign_purple")
	print(Globals.DEPTH)
	%DepthSlider.add_theme_stylebox_override("grabber", StyleBoxFlat.new())
	%DepthSlider.add_theme_stylebox_override("grabber_area", StyleBoxFlat.new())
	$DepthSlider.add_theme_stylebox_override("grabber_area_highlight", StyleBoxFlat.new())
	slider_stylebox = %DepthSlider.get_theme_stylebox("slider").duplicate()
	grabber_area_stylebox = %DepthSlider.get_theme_stylebox("grabber_area").duplicate()
	grabber_area_highlight_stylebox = %DepthSlider.get_theme_stylebox("grabber_area_highlight").duplicate()
	
	$PlayerShip.load_ship()
	$PlayerShip.scale = Vector2(.6,.6)
	if(Globals.DEPTH > %DepthSlider.min_value and Globals.DEPTH <= %DepthSlider.max_value):
		%DepthSlider.value = Globals.DEPTH
		var scalesize = %DepthSlider.max_value - %DepthSlider.min_value
		var scalepoint = %DepthSlider.value - %DepthSlider.min_value
		var difficulty = (float(scalepoint / scalesize) * (SCALE_END - SCALE_START)) + SCALE_START
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

func GetColor(value):
	var start_color = Color(0.68, 0.85, 0.90)  # Light blue
	var end_color = Color(0.00, 0.00, 0.55)  # Dark blue	

	var t = float(value - %DepthSlider.min_value) / (%DepthSlider.max_value - %DepthSlider.min_value)
	return start_color.lerp(end_color, t)
	

func _on_depth_slider_value_changed(value):
	var color = GetColor(value)
	slider_stylebox.bg_color = color
	grabber_area_stylebox.bg_color = color
	grabber_area_highlight_stylebox.bg_color = color
	#%DepthSlider.add_theme_stylebox_override("slider", slider_stylebox)
	%DepthSlider.add_theme_stylebox_override("grabber_area", grabber_area_stylebox)
	%DepthSlider.add_theme_stylebox_override("grabber_area_highlight", grabber_area_highlight_stylebox)
	
	if value >= %DepthSlider.min_value and value <= 6700:
		$BackgroundLevel1Version1.visible = true
		$BackgroundLevel2.visible = false
		$BackgroundLevel3.visible = false
	elif value > 6700 and value <= 8400:
		$BackgroundLevel1Version1.visible = false
		$BackgroundLevel2.visible = true
		$BackgroundLevel3.visible = false
	elif value > 8400:
		$BackgroundLevel1Version1.visible = false
		$BackgroundLevel2.visible = false
		$BackgroundLevel3.visible = true
	
	
	
