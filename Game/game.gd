extends Node2D


signal fullResources

func _ready():
	$ProgressBar.value = Globals.RESOURCES_COLLECTED
	$Victory.visible = false
	Globals.VIEWPORT_CENTER = get_viewport().size * 0.5
	$Timer.wait_time = Globals.SPAWN_SPEED 

func _physics_process(delta):
	Globals.RESOURCES_COLLECTED += Globals.COLLECTION_RATE * delta
	$ProgressBar.value = Globals.RESOURCES_COLLECTED
	if Globals.RESOURCES_COLLECTED >= Globals.MAX_RESOURCES:
		$Victory/ResourcesCollected.text = str("You collected ", Globals.MAX_RESOURCES, " resources worth ", Globals.MAX_RESOURCES,"$.")
		$Victory.visible = true

func _on_return_to_surface_pressed():
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")

func spawn_enemy():
	var new_enemy = preload("res://Game/Enemies/enemy_1.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_enemy.global_position = %PathFollow2D.global_position
	add_child(new_enemy)


func _on_timer_timeout():
	spawn_enemy()
