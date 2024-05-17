extends ParallaxBackground

func _process(delta):
	scroll_offset.x -= Globals.SPEED / 100
