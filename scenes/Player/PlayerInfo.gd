extends Control

var player_name: String = ""
var player_age: int = 0

func _ready() -> void:
	$SubmitButton.pressed.connect(_on_SubmitButton_pressed)

func _on_SubmitButton_pressed() -> void:
	player_name = $NameInput.text
	player_age = int($AgeInput.value)

	var file := FileAccess.open("user://player_data.save", FileAccess.WRITE)
	var data := {
		"name": player_name,
		"age": player_age
	}
	file.store_line(JSON.stringify(data))

	# Save to Global singleton
	Global.player_name = player_name
	Global.player_age = player_age

	print("Saved Player - Name:", player_name, ", Age:", player_age)
	get_tree().change_scene_to_file("res://scenes/Loading.tscn")
