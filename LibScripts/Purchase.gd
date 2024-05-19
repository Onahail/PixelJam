"""
Handles all aspects of purchasing ship modules in the shop.
"""

extends Node2D
class_name Purchase

var draggable = false
var purchased = false
var is_inside_droppable = false
var offset: Vector2
var initialPos : Vector2
var shopPos : Vector2
var drop_points = []
var drop_point
var mouseOverBody = false
var mousedOverModule = null
var hull_marker
var params = PhysicsPointQueryParameters2D.new()
var removed_droppable_under_me = false

var testCount = 0

#PURCHASING
var price = null #default
@export var module_name = "Default"

func _ready():
	pass
	
	
func _process(_delta):
	if Globals.is_dragging == true:
		UpdateColor()
	
	if get_tree().current_scene.name != "ShipBuilder":
		return
	if draggable and !purchased:
		if Input.is_action_just_pressed("leftclick"):
			offset = get_global_mouse_position()
			Globals.is_dragging = true
			z_index = 3
			scale = Vector2(0.7,0.7)
		if Input.is_action_pressed("leftclick"):
			global_position = get_global_mouse_position()
		elif Input.is_action_just_released("leftclick"):
			scale = Vector2(1,1)
			Globals.is_dragging = false
			if EligibleForPurchase():
				CalculateDropPosition()
			else:
				DeleteItem()
	
	if Input.is_action_just_pressed("rightclick") and !Globals.MOUSE_IN_SHOP and draggable and module_name == "Hull" and !Globals.is_dragging:
		if global_position != shopPos:
			var found_child = false
			for child in self.get_node("HullTile").get_children():
				if child is Module:
					found_child = true
					Globals.PLAYER_CURRENCY += child.price
					EventBus.item_sold.emit(child.module_name)
					child.drop_point.add_to_group("droppable")
					child.DeleteItem()
			if found_child == false and Globals.modulesOnShip["Hull"] > 1:
				Globals.PLAYER_CURRENCY += price
				EventBus.item_sold.emit(module_name)
				GenerateMarker()
				Globals.ship_config[self.x][self.y] = "0"
				Globals.HULLS.erase(self)
				DeleteItem()
				
			
func GenerateMarker():
	var marker = load(ModuleStats.module_data["Hull"]["assets"]["expansion_marker"])
	hull_marker = marker.instantiate()
	hull_marker.global_position = global_position
	hull_marker.x = self.x
	hull_marker.y = self.y
	self.get_parent().add_child(hull_marker)
			
func DeleteItem():
	queue_free()

func CalculateDropPosition():
	if is_inside_droppable:
		var closest_distance = INF
		for point in drop_points:
			var distance = global_position.distance_to(point.global_position)
			if distance < closest_distance:
				closest_distance = distance
				drop_point = point
		var result = CheckDropPositionEligibility(drop_point.global_position)
		if result:
			drop_point.modulate = Color(1,1,1,1)
			var tween = get_tree().create_tween()
			tween.tween_property(self, "global_position", drop_point.global_position,0.2).set_ease(Tween.EASE_OUT)
			tween.tween_callback(ChangeParent)

			Globals.PLAYER_CURRENCY -= price
			purchased = true
			drop_point.remove_from_group("droppable")
			$InstallModule.play()
			EventBus.item_purchased.emit(module_name)
			if module_name == "Hull":
				self.x = drop_point.x
				self.y = drop_point.y
				Globals.ship_config[drop_point.x][drop_point.y] = "Hull"
				Globals.HULLS.append(self)
		else:
			#EventBus.invalid_module_position.emit(module_name)
			DeleteItem()
	else:
		EventBus.module_stacked.emit(module_name)
		DeleteItem()

func CheckDropPositionEligibility(point: Vector2) -> bool:

	
	#OFFSETS
	var top = Vector2(0, -64)
	var bottom = Vector2(0, 64)
	var top_left = Vector2(-76, -32)
	var top_right = Vector2(76, -32)
	var bottom_left = Vector2(-76, 32)
	var bottom_right = Vector2(76,32)

	var offsets = {
		"Propeller": [top_left, bottom_left],  # Top left and bottom left
		"Bridge": [top_right, bottom_right],  # Top right and bottom right
		"Scoop": [top, bottom],  # Directly above and below
		"Hull": [top, bottom, top_left, top_right, bottom_left, bottom_right]
	}
	var results = []
	var area = get_world_2d().direct_space_state
	
	if module_name in offsets:
		var count = 0
		for offset in offsets[module_name]:
			var check_pos = point + offset
			params.position = check_pos
			
			var collision_check = area.intersect_point(params)
			if(collision_check.size() > 0):
				for thing in collision_check:
					if self.module_name == "Hull":
						if(thing["collider"] == self.get_node("HullTile")):
							count += 1
				if(count == 0):
					results.append({
						"check": collision_check,
						"offset": offset
					})
		count = 0
		var propeller_found_right = false
		var scoop_found_vertical = false
		var bridge_found_left = false
		for result in results:
			if result["check"].size() > 0:
				
				var collider = result["check"][0]["collider"]
				var offset = result["offset"]
				if collider.body_name != "expansion_marker":
					count += 1
				elif(collider.body_name == "expansion_marker" and Globals.ship_config[collider.x][collider.y] == "Hull"):
					count += 1
				if collider.get_parent().name != "PlayerShip":
					if module_name == "Hull":
						for child in collider.get_parent().get_node("HullTile").get_children():
							if child is Module:
								#Check for propeller or scoops by comparing current offset in the for loop with the offset that determined its placement
								if child.module_name == "Propeller" and (offset == top_right or offset == bottom_right):
									propeller_found_right = true
								elif child.module_name == "Scoop" and (offset == top or offset == bottom):
									scoop_found_vertical = true
								elif child.module_name == "Bridge" and (offset == top_left or offset == bottom_left):
									bridge_found_left = true
			#If no hull tiles, allow placement anywhere
		if module_name == "Hull" and Globals.modulesOnShip["Hull"] == 0: return true
			#Propeller only checks tiles to its left. If theres any hull spaces it cant be placed
		if ((module_name == "Propeller" and count > 0) or 
			#Scoop only checks for areas directly above or below it.
			(module_name == "Scoop" and count > 1) or 
			(module_name == "Bridge" and count > 0) or 
			#Hull wont be allowed to be placed if all surrouning spaces are expansion markers or to the left of propellers, or above/below scoops
			(module_name == "Hull" and (count == 0 or propeller_found_right == true or scoop_found_vertical == true or bridge_found_left == true ))):
				if Globals.is_dragging == false:
					if propeller_found_right == true:
						EventBus.hull_placed_behind_propeller.emit()
						return false
					elif scoop_found_vertical == true:
						EventBus.hull_placed_above_or_below_scoop.emit()
						return false
					elif bridge_found_left == true:
						EventBus.hull_placed_right_of_bridge.emit()
						return false
					else:
						EventBus.invalid_module_position.emit(module_name)
				return false
	else:
		pass

	return true 
	

func ChangeParent():
	self.get_parent().remove_child(self)
	if module_name == "Hull":
		drop_point.get_parent().add_child(self)
		#drop_point.queue_free()
	else:
		drop_point.add_child(self)
		global_position = drop_point.global_position
		if module_name == "Scoop":
			$".".FlipScoop()


func UpdateColor():
	if Globals.is_dragging == true:
		var closest_distance = INF
		var closest_node = null
		for point in drop_points:
			if point != null:
				var distance = global_position.distance_to(point.global_position)
				if distance < closest_distance:
					closest_distance = distance
					closest_node = point
		var closest_count = 0
		for point in drop_points:
			if point != null:
				var distance = global_position.distance_to(point.global_position)
				if distance == closest_distance:
					closest_count += 1
		
		for point in drop_points:
			if point != null:
				var distance = global_position.distance_to(point.global_position)
				if point == closest_node and closest_count == 1:
					if module_name == "Hull":
						point.get_node("AnimatedSprite2D").visible = true
						if CheckDropPositionEligibility(point.global_position) == false:
							point.get_node("AnimatedSprite2D").modulate = Color(Color.RED, 0.2)
						else:
							point.get_node("AnimatedSprite2D").modulate = Color(Color.GREEN, 0.2)
					if (point.get_child_count() < 3):
						if CheckDropPositionEligibility(point.global_position) == false:
							point.modulate = Color(Color.RED, 0.5)
						else:
							point.modulate = Color(Color.GREEN, 0.5)
				else:
					if module_name == "Hull":
						point.get_node("AnimatedSprite2D").visible = false
					point.modulate = Color(1,1,1,1)

	
func _on_area_2d_mouse_entered():
	mouseOverBody = true
	if get_tree().current_scene.name == "ShipBuilder":
			if not Globals.is_dragging:
				draggable = true
				scale = Vector2(1.05,1.05)
		
func _on_area_2d_mouse_exited():
	mouseOverBody = false
	if get_tree().current_scene.name == "ShipBuilder":
		if not Globals.is_dragging:
			draggable = false
			scale = Vector2(1,1)

func _on_area_2d_body_entered(body):
	if get_tree().current_scene.name == "ShipBuilder":
		print(module_name, " : ", body)
		print(body.get_parent().module_name, " : ", body.is_in_group('droppable'))
		if removed_droppable_under_me != true:
			if module_name != "Hull":
				drop_point = body
				drop_point.remove_from_group('droppable')
				print(body, " : ", body.is_in_group('droppable'))
				removed_droppable_under_me = true
	if body.is_in_group('droppable'):
		drop_points.append(body)
		is_inside_droppable = true
	

func _on_area_2d_body_exited(body):
	if module_name == "Hull" and get_tree().current_scene.name == "ShipBuilder":
		body.get_node("AnimatedSprite2D").visible = false
	body.modulate = Color(1,1,1,1)
	if body.is_in_group('droppable'):
		drop_points.erase(body)
		if drop_points.size() == 0:
			is_inside_droppable = false
		body.modulate = Color(1,1,1,1)

func EligibleForPurchase():
	if price > Globals.PLAYER_CURRENCY:
		EventBus.item_too_expensive.emit()
		return false
	if Globals.modulesOnShip[module_name] == ModuleStats.module_data[module_name]["max_allowable"]:
		EventBus.too_many_modules.emit(module_name)
		return false
	return true
