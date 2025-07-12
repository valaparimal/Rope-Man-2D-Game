extends Control

@onready var question_label = $QuestionLabel
@onready var score_label = $ScoreLabel
@onready var number_container = $NumberContainer
@onready var spawn_timer: Timer = $NumberSpawner

# New UI nodes
@onready var wrong_panel = $WrongPanel
@onready var explanation_label = $WrongPanel/ExplanationLabel
@onready var ok_button = $WrongPanel/OkButton

#instuction
@onready var instruction_panel = $InstructionPanel
@onready var instruction_ok_button = $InstructionPanel/OkButton

#help
@onready var help_button = $HelpControl/HelpButton

var last_window_size = Vector2.ZERO

var correct_answer = 0
var base_number = 0
var score = 0

func _ready():
	MathBgm.allow_music = true
	if not MathBgm.player.playing:
		MathBgm.player.play()
	randomize()
	generate_question()
	score_label.text = "Score: %d" % score

	wrong_panel.visible = false
	ok_button.pressed.connect(on_ok_pressed)

	spawn_timer.wait_time = 1.2
	spawn_timer.timeout.connect(spawn_number)
	spawn_timer.start()
	
	#instruction
	instruction_ok_button.pressed.connect(_on_instruction_ok_button_pressed)
	help_button.pressed.connect(_on_help_button_pressed)
	
	
	# for screen formation
	
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




func generate_question():
	base_number = randi_range(9, 18)
	correct_answer = randi_range(0, 9)
	var total = base_number - correct_answer
	question_label.text = "%d - ? = %d" % [base_number, total]

func spawn_number():
	var number = randi_range(0, 9)
	var label = Label.new()
	label.text = str(number)
	label.add_theme_font_size_override("font_size", 48)
	label.set_meta("value", number)
	label.position = Vector2(randi_range(50, 900), -30)
	label.mouse_filter = Control.MOUSE_FILTER_STOP

	label.gui_input.connect(func(event):
		if event is InputEventMouseButton and event.pressed:
			on_number_clicked(label)
	)

	number_container.add_child(label)

	var tween = create_tween()
	tween.tween_property(label, "position", Vector2(label.position.x, 1000), 8.0).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(Callable(label, "queue_free"))  # Free after animation ends

func on_number_clicked(label: Label):
	var value = int(label.get_meta("value"))
	label.queue_free()
	if value == correct_answer:
		score += 1
		score_label.text = "Score: %d" % score
		generate_question()
	else:
		explain_wrong(value)

func explain_wrong(selected_value):
	var correct_total = base_number - correct_answer
	var wrong_total = base_number - selected_value
	explanation_label.text = "%d - %d = %d, but we need %d → That's wrong!" % [
		base_number, selected_value, wrong_total, correct_total
	]
	wrong_panel.visible = true
	spawn_timer.stop()

func on_ok_pressed():
	ButtonClickBgm.allow_music = true
	ButtonClickBgm.player.play()
	wrong_panel.visible = false
	spawn_timer.start()


func _on_instruction_ok_button_pressed():
	ButtonClickBgm.allow_music = true
	ButtonClickBgm.player.play()
	instruction_panel.visible = false
	spawn_timer.start()

func _on_help_button_pressed():
	ButtonClickBgm.allow_music = true
	ButtonClickBgm.player.play()
	instruction_panel.visible = true
	spawn_timer.stop()

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

func adjust_scaledown_to_window():
	var root = self  # Change if your actual scalable content is a child (e.g., $Sprite)
	var screen_size = get_viewport().get_visible_rect().size
	var texture_size = last_window_size  # Or your designed/base resolution

	var scale_factor = screen_size / texture_size
	root.scale = Vector2(
		min(scale_factor.x, scale_factor.y),  # Maintain aspect ratio
		min(scale_factor.x, scale_factor.y)
	)
