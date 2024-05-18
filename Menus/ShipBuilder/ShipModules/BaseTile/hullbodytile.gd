extends StaticBody2D

@export var body_name = "hull_tile"

func _ready():
	$AnimatedSprite2D.play("base_tile_animation")
	if get_tree().current_scene.name == "Game":
		self.set_collision_layer_value(2, false)
	if get_tree().current_scene.name == "ShipBuilder":
		self.set_collision_layer_value(2, true)
