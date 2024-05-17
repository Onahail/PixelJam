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

#PURCHASING
var price = null #default
@export var module_name = "Default"

	
func _process(_delta):
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
	if Input.is_action_just_pressed("rightclick") and draggable:
			if global_position != shopPos:
				Globals.PLAYER_CURRENCY += price
				EventBus.item_sold.emit(module_name)
				drop_point.add_to_group("droppable")
				DeleteItem()

			
func CalculateDropPosition():
	if is_inside_droppable:
		var tween = get_tree().create_tween()
		var closest_distance = INF
		for point in drop_points:
			var distance = global_position.distance_to(point.global_position)
			if distance < closest_distance:
				closest_distance = distance
				drop_point = point
		tween.tween_property(self, "global_position", drop_point.global_position,0.2).set_ease(Tween.EASE_OUT)
		drop_point.modulate = Color(1,1,1,1)
		Globals.PLAYER_CURRENCY -= price
		purchased = true
		drop_point.remove_from_group("droppable")
		EventBus.item_purchased.emit(module_name)
	else:
		EventBus.module_stacked.emit(module_name)
		DeleteItem()

func UpdateColor():
	var closest_distance = INF
	for point in drop_points:
		var distance = global_position.distance_to(point.global_position)
		if distance < closest_distance:
			closest_distance = distance
	
	var closest_count = 0
	for point in drop_points:
		var distance = global_position.distance_to(point.global_position)
		if distance == closest_distance:
			closest_count += 1

	for point in drop_points:
		var distance = global_position.distance_to(point.global_position)
		if distance == closest_distance and closest_count == 1:
			point.modulate = Color(Color.GREEN, 0.5)
		else:
			point.modulate = Color(1,1,1,1)

func DeleteItem():
	queue_free()
	
func _on_area_2d_mouse_entered():
	mouseOverBody = true
	if get_tree().current_scene.name != "ShipBuilder":
		return
	if not Globals.is_dragging:
		draggable = true
		scale = Vector2(1.05,1.05)
		
func _on_area_2d_mouse_exited():
	mouseOverBody = false
	if get_tree().current_scene.name != "ShipBuilder":
		return
	if not Globals.is_dragging:
		draggable = false
		scale = Vector2(1,1)

func _on_area_2d_body_entered(body):
	if body.is_in_group('droppable'):
		drop_points.append(body)
		is_inside_droppable = true


func _on_area_2d_body_exited(body):
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
