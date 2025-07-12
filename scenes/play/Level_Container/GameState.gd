extends Node

var unlocked_levels = {
	"level_1": true,
	"level_2": false,
	"level_3": false,
	"level_4": false,
	"level_5": false
}

func _ready():
	load_progress()

func unlock_level(level_name: String):
	unlocked_levels[level_name] = true
	save_progress()

func is_level_unlocked(level_name: String) -> bool:
	return unlocked_levels.get(level_name, false)

func save_progress():
	var file = FileAccess.open("user://levels.json", FileAccess.WRITE)
	if file:
		var json = JSON.stringify(unlocked_levels)
		file.store_line(json)
		file.close()

func load_progress():
	if FileAccess.file_exists("user://levels.json"):
		var file = FileAccess.open("user://levels.json", FileAccess.READ)
		if file:
			var json_string = file.get_line()
			var data = JSON.parse_string(json_string)
			if typeof(data) == TYPE_DICTIONARY:
				unlocked_levels = data
