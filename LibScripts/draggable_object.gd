extends Node2D

var draggable = false
var is_inside_droppable = false
var body_ref
var offset: Vector2
var initialPos : Vector2
var drop_points = []
var drop_point

func _process(delta):
	if get_tree().current_scene.name != "ShipBuilder":
		return
	if draggable:
		if Input.is_action_just_pressed("leftclick"):
			offset = get_global_mouse_position()
			Globals.is_dragging = true
			z_index = 2
			scale = Vector2(0.7,0.7)
		if Input.is_action_pressed("leftclick"):
			global_position = get_global_mouse_position()
		elif Input.is_action_just_released("leftclick"):
			scale = Vector2(1,1)
			Globals.is_dragging = false
			calculateDropPosition()
				
func calculateDropPosition():
	var tween = get_tree().create_tween()
	if is_inside_droppable:
		var closest_distance = INF
		for point in drop_points:
			var distance = global_position.distance_to(point.global_position)
			if distance < closest_distance:
				closest_distance = distance
				drop_point = point
		tween.tween_property(self, "global_position", drop_point.global_position,0.2).set_ease(Tween.EASE_OUT)
		body_ref.modulate = Color(1,1,1,1)
		#print("Inside Droppable Position")
	else:
		tween.tween_property(self, "global_position", initialPos,0.2).set_ease(Tween.EASE_OUT)
		#print("Outside Droppable Position - Returning")
