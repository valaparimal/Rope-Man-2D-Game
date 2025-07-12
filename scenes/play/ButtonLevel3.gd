extends Button

func _ready():
	if GameState.is_level_unlocked("level_3"):
		self.disabled = false
		self.pressed.connect(_on_button_pressed)
	else:
		self.disabled = true

func _on_button_pressed():
	ButtonClickBgm.allow_music = true
	ButtonClickBgm.player.play()	
	HomeBgMusic.allow_music = false
	HomeBgMusic.player.stop()
	get_tree().change_scene_to_file("res://scenes/play/Level_Container/level3/lavel3.tscn")  # Replace with your actual root scene path

