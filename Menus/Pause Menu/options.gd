extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")


func _input(_InputEvent):
	if get_tree().current_scene.name == "Game":
		if Input.is_action_just_pressed("Menu"):
			if get_tree().paused == true:
				get_tree().paused = false
				$".".visible = false
			else:
				get_tree().paused = true
				$".".visible = true
	
func _on_full_screen_toggled(toggled_on):
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
