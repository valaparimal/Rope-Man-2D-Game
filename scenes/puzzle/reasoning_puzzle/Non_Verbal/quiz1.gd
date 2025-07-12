extends Control

var last_window_size = Vector2.ZERO

# List of questions
var questions = [
	{
		"image": preload("res://scenes/puzzle/reasoning_puzzle/Non_Verbal/Quiz1_assets/question.png"),
		"correct": "b",
		"hint": "In the given question choose one of the answer figures from the given answer figures that will complete the pattern of the question."
	},
	{
		"image": preload("res://scenes/puzzle/reasoning_puzzle/Non_Verbal/Quiz1_assets/question2.jpg"),
		"correct": "a",
		"hint": "In the given question choose one of the answer figures from the given answer figures that will complete the pattern of the question."
	},
	{
		"image": preload("res://scenes/puzzle/reasoning_puzzle/Non_Verbal/Quiz1_assets/question3.jpg"),
		"correct": "b",
		"hint": "In each of the following questions, there is a special relationship between the two question figures. Choose one of the answer figures in place of the question mark which has a relationship with the third question figure."
	},
	{
		"image": preload("res://scenes/puzzle/reasoning_puzzle/Non_Verbal/Quiz1_assets/question4.jpg"),
		"correct": "b",
		"hint": "Choose the answer figure in which the question figure is hidden."
	},
	{
		"image": preload("res://scenes/puzzle/reasoning_puzzle/Non_Verbal/Quiz1_assets/questions5.jpg"),
		"correct": "d",
		"hint": "the similar figurs will be on the opposite faces of one another."
	},
	{
		"image": preload("res://scenes/puzzle/reasoning_puzzle/Non_Verbal/Quiz1_assets/questions6.jpg"),
		"correct": "d",
		"hint": "The Four Triangular portion will combine to form a face of type 1 which lies opposite to the face bearing the circle."
	},
	{
		"image": preload("res://scenes/puzzle/reasoning_puzzle/Non_Verbal/Quiz1_assets/question5.jpg"),
		"correct": "c",
		"hint": "In each of the following questions, there is a special relationship between the two question figures. Choose one of the answer figures in place of the question mark which has a relationship with the third question figure."
	},
	{
		"image": preload("res://scenes/puzzle/reasoning_puzzle/Non_Verbal/Quiz1_assets/question6.jpg"),
		"correct": "d",
		"hint": "In the given question choose one of the answer figures from the given answer figures that will complete the pattern of the question."
	},
	{
		"image": preload("res://scenes/puzzle/reasoning_puzzle/Non_Verbal/Quiz1_assets/question9.jpg"),
		"correct": "d",
		"hint": "Practice all english alphabet mirror image and Find answer."
	},
	{
		"image": preload("res://scenes/puzzle/reasoning_puzzle/Non_Verbal/Quiz1_assets/question7.jpg"),
		"correct": "b",
		"hint": "Choose the answer figure in which the question figure is hidden."
	},
	{
		"image": preload("res://scenes/puzzle/reasoning_puzzle/Non_Verbal/Quiz1_assets/question8.jpg"),
		"correct": "d",
		"hint": "Choose the answer figure in which the question figure is hidden."
	}
]

var current_question = 0
var answered_correctly = false

@onready var question_image = $QuestionImage
@onready var hint_label = $Panel/HintLabel
@onready var next_button =$Panel/NextButton
@onready var panel =$Panel
@onready var expression_label =$Panel/ExpressionLabel

func _ready():
	MathBgm.allow_music = true
	if not MathBgm.player.playing:
		MathBgm.player.play()
	
	load_question()
	
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

func load_question():
	var q = questions[current_question]
	question_image.texture = q["image"]
	#hint_label.text = ""
	panel.visible = false
	answered_correctly = false
	# Re-enable all buttons
	for b in $Buttons.get_children():
		b.disabled = false

func _on_button_pressed(answer: String):
	if answered_correctly:
		return # Already answered, don't accept more input

	
	panel.visible = true
	var q = questions[current_question]
	if answer == q["correct"]:
		hint_label.add_theme_color_override("font_color",Color(0,0.427,0))
		hint_label.text = "    Correct! Press 'Next Question' to continue."
		expression_label.text = "🥳"
		answered_correctly = true
		next_button.text = "Next Question"
		# Optional: disable answer buttons
		for b in $Buttons.get_children():
			b.disabled = true
	else:
		hint_label.add_theme_color_override("font_color",Color(255,0,0))
		hint_label.text = "    Hint: " + q["hint"]
		expression_label.text = "🤔"
		next_button.text = "Ok"
		answered_correctly = false

func _on_button_a_pressed():_on_button_pressed("a")
func _on_button_b_pressed(): _on_button_pressed("b")
func _on_button_c_pressed(): _on_button_pressed("c")
func _on_button_d_pressed(): _on_button_pressed("d")

func _on_next_button_pressed():
	if answered_correctly:
		current_question += 1
		if current_question < questions.size():
			load_question()
		else:
			hint_label.text = "    Quiz complete! You did it!"
			next_button.visible = false
	else :
		panel.visible = false

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

