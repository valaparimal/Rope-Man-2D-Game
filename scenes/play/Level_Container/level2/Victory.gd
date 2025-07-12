extends TextureRect


func _ready():
	self.mouse_filter = Control.MOUSE_FILTER_STOP
	self.gui_input.connect(_on_win_image_clicked)


func _on_win_image_clicked(event):
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to_file("res://scenes/play/level1/puzzle.tscn")
