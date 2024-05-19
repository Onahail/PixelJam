extends AudioStreamPlayer2D

var menu_music = preload("res://Music/MenuMusic.wav")
# Called when the node enters the scene tree for the first time.
func _ready():
	play_music(menu_music)

func play_music(stream):
	stream = stream
	play()
	
func stop_music():
	stop()
