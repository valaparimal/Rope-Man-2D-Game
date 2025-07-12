extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(_on_ok_button_pressed)

func _on_ok_button_pressed():
	ButtonClickBgm.allow_music = true
	ButtonClickBgm.player.play()	
	if get_parent().get_node("Victory").visible :
		get_tree().change_scene_to_file("res://scenes/play/Level_Container/level3/puzzle.tscn")  # Replace with your actual root scene path
	else :
		get_tree().change_scene_to_file("res://scenes/play/Lavel_Container.tscn")
