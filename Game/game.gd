extends Node2D


signal fullResources

func _ready():
	Globals.VIEWPORT_CENTER = get_viewport().size * 0.5
	$Timer.wait_time = Globals.SPAWN_RATE
	$PlayerShip.load_ship()
	Globals.calc_collection_rates()

func _physics_process(delta):
	Globals.RESOURCES_COLLECTED += Globals.COLLECTION_RATE * delta
	$ProgressBar.value =  Globals.RESOURCES_COLLECTED / Globals.MAX_RESOURCES * 100
	print("Collected: ", Globals.RESOURCES_COLLECTED, " - Max Resources: ", Globals.MAX_RESOURCES)
	print("Progress Bar Value = ", $ProgressBar.value)
	if Globals.RESOURCES_COLLECTED >= Globals.MAX_RESOURCES:
		get_tree().change_scene_to_file("res://Game/end_game_screen.tscn")
		
func spawn_enemy():
	var new_enemy = preload("res://Game/Enemies/jellyfish.tscn").instantiate()
	%JellyfishPath.progress_ratio = randf()
	new_enemy.global_position = %JellyfishPath.global_position
	add_child(new_enemy)


func _on_timer_timeout():
	spawn_enemy()


func _on_kill_box_body_entered(body):
	body.queue_free()

