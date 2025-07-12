extends Control

@onready var question_label = $QuestionLabel
@onready var input_field = $CodeInput
@onready var check_button = $CheckButton
@onready var result_label = $ResultLabel
@onready var unlock_image = $UnlockImage

var last_window_size = Vector2.ZERO

var correct_code = "563"

func _ready():
	result_label.visible = false
	check_button.pressed.connect(on_check_pressed)
	unlock_image.set_pivot_offset(unlock_image.size / 2)  # Center pivot
	
	# Enable input on TextureRect
	unlock_image.mouse_filter = Control.MOUSE_FILTER_STOP
	unlock_image.gui_input.connect(_on_unlock_image_clicked)
	
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
			last_window_size = get_viewport().get_visible_rect().size
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
	
	
func adjust_scaledown_to_window():
	var root = self  # Change if your actual scalable content is a child (e.g., $Sprite)
	var screen_size = get_viewport().get_visible_rect().size
	var texture_size = last_window_size  # Or your designed/base resolution

	var scale_factor = screen_size / texture_size
	root.scale = Vector2(
		min(scale_factor.x, scale_factor.y),  # Maintain aspect ratio
		min(scale_factor.x, scale_factor.y)
	)

func on_check_pressed():
	var entered = input_field.text.strip_edges()
	result_label.visible = true
	if entered == correct_code:
		GameState.unlock_level("level_3")
		result_label.text = "Correct! You've unlocked Level 3!"
		unlock_image.visible=true
		unlock_image.scale = Vector2.ZERO
		var tween = create_tween()
		tween.tween_property(unlock_image, "scale", Vector2(1, 1), 2.0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	else:
		result_label.text="That's not correct.
Hint:
--> First digit = last + 2
--> Middle digit = last × 2
--> Total sum = 14"

func _on_unlock_image_clicked(event):
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to_file("res://scenes/play/Lavel_Container.tscn")
