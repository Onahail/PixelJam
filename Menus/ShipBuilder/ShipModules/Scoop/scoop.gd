extends Module



func _ready():
	
	#CHANGE VALUES
	module_name = "Scoop"
	#CALL ORIGINAL
	super._ready()
	
#func _process(_delta):
#	if get_parent().name == "HullTile":
#		FlipScoop()

func _on_hp_depleted():
	#TODO Scoop Destroyed
	super._on_hp_depleted()
	pass

func FlipScoopOnLoad():
		print("FlipScoopOnLoad Called")
		$DownScoop.visible = false
		$UpScoop.visible = true

func FlipScoop():
	#print("FlipScoop called")
	#OFFSETS
	#top = Vector2(0, -64)
	#bottom = Vector2(0, 64)
	#top_left = Vector2(-76, -32)
	#top_right = Vector2(76, -32)
	#bottom_left = Vector2(−76,32)
	#bottom_right = Vector2(76,32)
	
	
	var area = get_world_2d().direct_space_state
	var check_pos = self.global_position + Vector2(0, 64)
	var params = PhysicsPointQueryParameters2D.new()
	var count = 0
	params.position = check_pos
	params.collide_with_areas = true
	var results = area.intersect_point(params)	
	if results[0]["collider"].body_name != "expansion_marker":
		$DownScoop.visible = false
		$UpScoop.visible = true
