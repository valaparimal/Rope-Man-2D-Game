extends Node

var player_name: String = ""
var player_age: int = 0

func load_player_data() -> void:
	if FileAccess.file_exists("user://player_data.save"):
		var file := FileAccess.open("user://player_data.save", FileAccess.READ)
		var data: Dictionary = JSON.parse_string(file.get_line())
		if typeof(data) == TYPE_DICTIONARY:
			player_name = data.get("name", "")
			player_age = data.get("age", 0)
