extends Control

var last_window_size = Vector2.ZERO
var language := "en"  # Default language

# List of bilingual science questions
var questions = [
	{
		"en": {
			"question": "Which part of a plant makes food?",
			"options": ["Root", "Leaf", "Stem", "Flower"],
			"hint": "Hint: It contains chlorophyll and is flat to capture sunlight."
		},
		"hi": {
			"question": "पौधे का कौन सा भाग भोजन बनाता है?",
			"options": ["जड़", "पत्ता", "तना", "फूल"],
			"hint": "संकेत: इसमें क्लोरोफिल होता है और यह सूर्य की रोशनी पकड़ने के लिए चपटा होता है।"
		},
		"correct": "b"
	},
	{
		"en": {
			"question": "Which gas do we breathe in that is essential for life?",
			"options": ["Carbon Dioxide", "Oxygen", "Nitrogen", "Hydrogen"],
			"hint": "Hint: It is the gas plants release during photosynthesis."
		},
		"hi": {
			"question": "हम कौन सी गैस साँस में लेते हैं जो जीवन के लिए आवश्यक है?",
			"options": ["कार्बन डाइऑक्साइड", "ऑक्सीजन", "नाइट्रोजन", "हाइड्रोजन"],
			"hint": "संकेत: यह वह गैस है जो पौधे प्रकाश संश्लेषण के दौरान छोड़ते हैं।"
		},
		"correct": "b"
	},
	{
		"en": {
			"question": "What is the boiling point of water?",
			"options": ["50°C", "100°C", "0°C", "37°C"],
			"hint": "Hint: Water turns to steam at this temperature."
		},
		"hi": {
			"question": "पानी का क्वथनांक क्या है?",
			"options": ["50°C", "100°C", "0°C", "37°C"],
			"hint": "संकेत: इस तापमान पर पानी भाप में बदलता है।"
		},
		"correct": "b"
	},
	{
		"en": {
			"question": "What do bees collect from flowers to make honey?",
			"options": ["Water", "Seeds", "Nectar", "Pollen"],
			"hint": "Hint: It's the sweet liquid found inside flowers."
		},
		"hi": {
			"question": "मधुमक्खियाँ फूलों से क्या इकट्ठा करती हैं जिससे शहद बनता है?",
			"options": ["पानी", "बीज", "रस (नेक्टर)", "पराग (पोलन)"],
			"hint": "संकेत: यह फूलों के अंदर पाया जाने वाला मीठा तरल होता है।"
		},
		"correct": "c"
	},
	{
		"en": {
			"question": "Which of these is a source of energy?",
			"options": ["Plastic", "Rock", "Sun", "Paper"],
			"hint": "Hint: It's a natural source of heat and light."
		},
		"hi": {
			"question": "इनमें से कौन ऊर्जा का स्रोत है?",
			"options": ["प्लास्टिक", "पत्थर", "सूरज", "कागज"],
			"hint": "संकेत: यह गर्मी और प्रकाश का एक प्राकृतिक स्रोत है।"
		},
		"correct": "c"
	}
]

var current_question = 0
var answered_correctly = false

@onready var question_label = $QuestionLabel
@onready var hint_label = $Panel/HintLabel
@onready var next_button = $Panel/NextButton
@onready var panel = $Panel
@onready var expression_label = $Panel/ExpressionLabel
@onready var language_button = $LanguageButton

func _ready():
	MathBgm.allow_music = true
	if not MathBgm.player.playing:
		MathBgm.player.play()
		
	load_question()
	panel.visible = false
	update_language_button_text()

	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		var size = get_viewport().get_visible_rect().size
		DisplayServer.window_set_size(size)
		DisplayServer.window_set_min_size(size)
		DisplayServer.window_set_max_size(size)
		last_window_size = size
	else:
		adjust_scaleup_to_window()

func _process(_delta):
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_MAXIMIZED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		last_window_size = get_viewport().get_visible_rect().size
		adjust_scaleup_to_window()

func load_question():
	var q = questions[current_question][language]
	question_label.text = q["question"]
	var options = q["options"]
	$Buttons/ButtonA.text = "A. " + options[0]
	$Buttons/ButtonB.text = "B. " + options[1]
	$Buttons/ButtonC.text = "C. " + options[2]
	$Buttons/ButtonD.text = "D. " + options[3]

	panel.visible = false
	answered_correctly = false
	for b in $Buttons.get_children():
		b.disabled = false

func _on_button_pressed(answer: String):
	if answered_correctly:
		return

	panel.visible = true
	var q = questions[current_question]
	if answer == q["correct"]:
		hint_label.add_theme_color_override("font_color", Color(0, 0.427, 0))
		hint_label.text = "    Correct! Press 'Next Question' to continue." if language == "en" else "    सही! जारी रखने के लिए 'अगला प्रश्न' दबाएं।"
		expression_label.text = "🥳"
		answered_correctly = true
		next_button.text = "Next Question" if language == "en" else "अगला प्रश्न"
		for b in $Buttons.get_children():
			b.disabled = true
	else:
		hint_label.add_theme_color_override("font_color", Color(1, 0, 0))
		hint_label.text = "    " + q[language]["hint"]
		expression_label.text = "🤔"
		next_button.text = "Ok" if language == "en" else "ठीक है"

func _on_button_a_pressed(): _on_button_pressed("a")
func _on_button_b_pressed(): _on_button_pressed("b")
func _on_button_c_pressed(): _on_button_pressed("c")
func _on_button_d_pressed(): _on_button_pressed("d")

func _on_next_button_pressed():
	if answered_correctly:
		current_question += 1
		if current_question < questions.size():
			load_question()
		else:
			hint_label.text = "    Quiz complete! You did it!" if language == "en" else "    प्रश्नोत्तरी समाप्त! आपने कर दिखाया!"
			next_button.visible = false
	else:
		panel.visible = false

func _on_language_button_pressed():
	language = "hi" if language == "en" else "en"
	update_language_button_text()
	if current_question < questions.size():
		load_question()
	else :
		hint_label.text = "    Quiz complete! You did it!" if language == "en" else "    प्रश्नोत्तरी समाप्त! आपने कर दिखाया!"
		next_button.visible = false

func update_language_button_text():
	language_button.text = "Switch to Hindi" if language == "en" else "अंग्रेज़ी में बदलें"

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			var size = get_viewport().get_visible_rect().size
			DisplayServer.window_set_size(size)
			DisplayServer.window_set_min_size(size)
			DisplayServer.window_set_max_size(size)
			last_window_size = size
			adjust_scaledown_to_window()

func adjust_scaleup_to_window():
	var root = self
	var screen_size = get_viewport().get_visible_rect().size
	var texture_size = Vector2(1920, 1080)
	var scale_factor = screen_size / texture_size
	root.scale = Vector2(
		min(scale_factor.x, scale_factor.y) * 1.671,
		min(scale_factor.x, scale_factor.y) * 1.67
	)

func adjust_scaledown_to_window():
	var root = self
	var screen_size = get_viewport().get_visible_rect().size
	var texture_size = last_window_size
	var scale_factor = screen_size / texture_size
	root.scale = Vector2(
		min(scale_factor.x, scale_factor.y),
		min(scale_factor.x, scale_factor.y)
	)
