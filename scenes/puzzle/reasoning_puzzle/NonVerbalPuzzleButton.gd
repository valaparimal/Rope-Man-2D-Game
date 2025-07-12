extends Button

func _ready():
	self.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	ButtonClickBgm.allow_music = true
	ButtonClickBgm.player.play()
	HomeBgMusic.allow_music = false
	HomeBgMusic.player.stop()
	get_tree().change_scene_to_file("res://scenes/puzzle/reasoning_puzzle/Non_Verbal/Quiz1.tscn")  # Replace with your actual root scene path
	
