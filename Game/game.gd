extends Node2D


signal fullResources

func _ready():
	Globals.VIEWPORT_CENTER = get_viewport().size * 0.5
	$PlayerShip.load_ship()
	Globals.calc_collection_rates()
	Globals.RESOURCES_COLLECTED = 0

func _physics_process(delta):
	$Timer.wait_time = Globals.SPAWN_RATE
	Globals.RESOURCES_COLLECTED += Globals.COLLECTION_RATE * delta
	$ProgressBar.value =  Globals.RESOURCES_COLLECTED / Globals.MAX_RESOURCES * 100
	#print("Collected: ", Globals.RESOURCES_COLLECTED, " - Max Resources: ", Globals.MAX_RESOURCES)
	#print("Progress Bar Value = ", $ProgressBar.value)
	if Globals.RESOURCES_COLLECTED >= Globals.MAX_RESOURCES:
		get_tree().change_scene_to_file("res://Game/end_game_screen.tscn")
		#TODO Math for actual value per resource
		Globals.GameWin()
	if Globals.modulesOnShip["Propeller"] == 0 or Globals.modulesOnShip["Scoop"] == 0:
		Globals.GameLoss()	
		
func spawn_enemy():
	var new_enemy = preload("res://Game/Enemies/jellyfish.tscn").instantiate()
	%JellyfishPath.progress_ratio = randf()
	new_enemy.global_position = %JellyfishPath.global_position
	add_child(new_enemy)


func _on_timer_timeout():
	spawn_enemy()


func _on_kill_box_body_entered(body):
	body.queue_free()

