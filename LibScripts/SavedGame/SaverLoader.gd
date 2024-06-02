extends Node
class_name SaverLoader

func save_game():
	var savedata:SaveData = SaveData.new()
	var saved_data:Array[SaveData] = []
	get_tree().call_group("persistant", "on_save_game", saved_data)
	savedata.saved_data = saved_data
		
	ResourceSaver.save(savedata, "user://savedgame.tres")

func load_game():
	var savedata:SaveData = load("user://savedgame.tres") as SaveData
	get_tree().call_group("persistant", "on_before_load_game")
