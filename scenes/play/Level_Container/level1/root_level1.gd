extends Node

var last_window_size = Vector2.ZERO

func _ready():
	# Start in fullscreen
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	#last_window_size = get_viewport().get_visible_rect().size
	#adjust_scaleup_to_window()
	
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		var size = get_viewport().get_visible_rect().size
		DisplayServer.window_set_size(size)
		DisplayServer.window_set_min_size(size)
		DisplayServer.window_set_max_size(size)
		last_window_size = get_viewport().get_visible_rect().size
	else:
		adjust_scaleup_to_window()

func _process(_delta):
	# Only check this if we're not in fullscreen
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_MAXIMIZED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		last_window_size = get_viewport().get_visible_rect().size
		adjust_scaleup_to_window()

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			# Exit fullscreen and lock current window size
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			var size = get_viewport().get_visible_rect().size
			DisplayServer.window_set_size(size)
			DisplayServer.window_set_min_size(size)
			DisplayServer.window_set_max_size(size)
			last_window_size = size
			adjust_scaledown_to_window()
			
func adjust_scaleup_to_window():
	var root = self  # Change if your actual scalable content is a child (e.g., $Sprite)
	var screen_size = get_viewport().get_visible_rect().size
	var texture_size = Vector2(1920, 1080)  # Or your designed/base resolution

	var scale_factor = screen_size / texture_size
	root.scale = Vector2(
		min(scale_factor.x, scale_factor.y)*1.671,  # Maintain aspect ratio
		min(scale_factor.x, scale_factor.y)*1.67
	)
	
	root.position = Vector2(20,18) 
	
	
func adjust_scaledown_to_window():
	var root = self  # Change if your actual scalable content is a child (e.g., $Sprite)
	var screen_size = get_viewport().get_visible_rect().size
	var texture_size = last_window_size  # Or your designed/base resolution

	var scale_factor = screen_size / texture_size
	root.scale = Vector2(
		min(scale_factor.x, scale_factor.y),  # Maintain aspect ratio
		min(scale_factor.x, scale_factor.y)
	)
	root.position = Vector2(0,0)  
