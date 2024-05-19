extends Node2D

const JELLYFISH = preload("res://Game/Enemies/Jellyfish/jellyfish.tscn")
const BOMBSHARK = preload("res://Game/Enemies/Bomb_Shark/bombshark.tscn")
const LAUNCHERFISH = preload("res://Game/Enemies/Launcherfish/launcherfish.tscn")

signal fullResources

func _ready():
	MenuMusic.stop()
	Globals.VIEWPORT_CENTER = get_viewport().size * 0.5
	$PlayerShip.load_ship()
	Globals.calc_collection_rates()
	Globals.RESOURCES_COLLECTED = 0
	var ScaledDiff = float((Globals.DIFFICULTY - Globals.DIFF_SCALE_START) / (Globals.DIFF_SCALE_END - Globals.DIFF_SCALE_START))
	if(ScaledDiff <= 0.5):
		$ParallaxBackground/ParallaxLayer/Level1BackgroundSecondLayerPlaceholder.show()
		$ParallaxBackground/ParallaxLayer/Level2BackgroundSecondLayer.hide()
		$ParallaxBackground/BackgroundLevel1Version1.show()
		$ParallaxBackground/BackgroundLevel2.hide()
	elif(ScaledDiff > 0.5):
		$ParallaxBackground/ParallaxLayer/Level1BackgroundSecondLayerPlaceholder.hide()
		$ParallaxBackground/ParallaxLayer/Level2BackgroundSecondLayer.show()
		$ParallaxBackground/BackgroundLevel1Version1.hide()
		$ParallaxBackground/BackgroundLevel2.show()

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
	$ProgressBar/Label.text = str("Resources Collected: ", int(Globals.RESOURCES_COLLECTED),"    Total Storage: ", Globals.MAX_RESOURCES)
func spawn_enemy():
	pass


func SpawnJellyfish():
	var new_jelly = JELLYFISH.instantiate()
	%EnemyPath.progress_ratio = randf()
	new_jelly.global_position = %EnemyPath.global_position
	add_child(new_jelly)

func SpawnShark():
	var new_shark = BOMBSHARK.instantiate()
	%EnemyPath.progress_ratio = randf()
	new_shark.global_position = %EnemyPath.global_position
	add_child(new_shark)

func SpawnLauncherFish():
	var new_launcherfish = LAUNCHERFISH.instantiate()
	%EnemyPath.progress_ratio = randf()
	new_launcherfish.global_position = %EnemyPath.global_position
	add_child(new_launcherfish)


func _on_timer_timeout():
	var ScaledDiff = float((Globals.DIFFICULTY - Globals.DIFF_SCALE_START) / (Globals.DIFF_SCALE_END - Globals.DIFF_SCALE_START))
	#print(ScaledDiff)
	var rng = RandomNumberGenerator.new()
	var rando = rng.randf_range(0, 1)
	if(ScaledDiff < 0.3):
		SpawnJellyfish()
	elif(ScaledDiff <= 0.6):
		if(rando < 0.5):
			SpawnJellyfish()
		else:
			SpawnShark()
	elif(ScaledDiff <= 1):
		if(rando < 0.333):
			SpawnJellyfish()
		elif(rando < 0.666):
			SpawnShark()
		else:
			SpawnLauncherFish()


func _on_kill_box_body_entered(body):
	body.queue_free()

