extends Button

func _ready():
	self.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	ButtonClickBgm.allow_music = true
	ButtonClickBgm.player.play()	
	MathBgm.allow_music = false
	MathBgm.player.stop()
	get_tree().change_scene_to_file("res://scenes/puzzle/reasoning_puzzle/reasoning_puzzle.tscn")  # Replace with your actual root scene path
	
