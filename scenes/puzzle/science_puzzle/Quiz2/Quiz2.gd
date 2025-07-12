extends Control

var last_window_size = Vector2.ZERO
var language := "en"  # Default language

# List of bilingual science questions
var questions = [
	{
		"en": {
			"question": "What is the largest planet in our solar system?",
			"options": ["Earth", "Mars", "Jupiter", "Saturn"],
			"hint": "Hint: It's known for its Great Red Spot."
		},
		"hi": {
			"question": "हमारे सौरमंडल का सबसे बड़ा ग्रह कौन सा है?",
			"options": ["पृथ्वी", "मंगल", "बृहस्पति", "शनि"],
			"hint": "संकेत: यह अपनी महान लाल धब्बे के लिए प्रसिद्ध है।"
		},
		"correct": "c"
	},
	{
		"en": {
			"question": "What is the freezing point of water?",
			"options": ["0°C", "-10°C", "5°C", "10°C"],
			"hint": "Hint: It's the point at which water turns into ice."
		},
		"hi": {
			"question": "पानी का ठंडा होने का बिंदु क्या है?",
			"options": ["0°C", "-10°C", "5°C", "10°C"],
			"hint": "संकेत: यह वह बिंदु है जब पानी बर्फ में बदलता है।"
		},
		"correct": "a"
	},
	{
		"en": {
			"question": "Which of the following animals can fly?",
			"options": ["Elephant", "Cat", "Bat", "Tiger"],
			"hint": "Hint: This animal is a mammal that can fly at night."
		},
		"hi": {
			"question": "निम्नलिखित में से कौन सा जानवर उड़ सकता है?",
			"options": ["हाथी", "बिल्ली", "चमगादड़", "बाघ"],
			"hint": "संकेत: यह एक स्तनपायी जानवर है जो रात में उड़ सकता है।"
		},
		"correct": "c"
	},
	{
		"en": {
			"question": "Which is the fastest land animal?",
			"options": ["Lion", "Cheetah", "Tiger", "Horse"],
			"hint": "Hint: This animal can reach speeds of up to 70 mph."
		},
		"hi": {
			"question": "सबसे तेज़ भूमि जानवर कौन सा है?",
			"options": ["सिंह", "चीता", "बाघ", "घोड़ा"],
			"hint": "संकेत: यह जानवर 70 मील प्रति घंटे तक की गति प्राप्त कर सकता है।"
		},
		"correct": "b"
	},
	{
		"en": {
			"question": "Which of these is a renewable source of energy?",
			"options": ["Coal", "Wind", "Natural Gas", "Nuclear"],
			"hint": "Hint: This energy source is generated from the movement of air."
		},
		"hi": {
			"question": "इनमें से कौन सा ऊर्जा का नवीकरणीय स्रोत है?",
			"options": ["कोयला", "हवाएँ", "प्राकृतिक गैस", "न्यूक्लियर"],
			"hint": "संकेत: यह ऊर्जा स्रोत हवा की गति से उत्पन्न होती है।"
		},
		"correct": "b"
	},
	{
		"en": {
			"question": "What is the chemical formula for water?",
			"options": ["H2O", "CO2", "O2", "H2O2"],
			"hint": "Hint: It consists of two hydrogen atoms and one oxygen atom."
		},
		"hi": {
			"question": "पानी का रासायनिक सूत्र क्या है?",
			"options": ["H2O", "CO2", "O2", "H2O2"],
			"hint": "संकेत: इसमें दो हाइड्रोजन परमाणु और एक ऑक्सीजन परमाणु होता है।"
		},
		"correct": "a"
	},
	{
		"en": {
			"question": "Which planet is known as the Red Planet?",
			"options": ["Mars", "Venus", "Mercury", "Jupiter"],
			"hint": "Hint: It's the fourth planet from the sun."
		},
		"hi": {
			"question": "कौन सा ग्रह लाल ग्रह के नाम से जाना जाता है?",
			"options": ["मंगल", "शुक्र", "बुध", "बृहस्पति"],
			"hint": "संकेत: यह सूर्य से चौथा ग्रह है।"
		},
		"correct": "a"
	},
	{
		"en": {
			"question": "What is the powerhouse of the cell?",
			"options": ["Nucleus", "Mitochondria", "Ribosome", "Endoplasmic Reticulum"],
			"hint": "Hint: This organelle is responsible for energy production in the cell."
		},
		"hi": {
			"question": "कोशिका का ऊर्जा उत्पादन केन्द्र कौन सा है?",
			"options": ["न्यूक्लियस", "माइटोकॉन्ड्रिया", "रिबोसोम", "एंडोप्लाज्मिक रेटिकुलम"],
			"hint": "संकेत: यह अंगिका कोशिका में ऊर्जा उत्पादन के लिए जिम्मेदार है।"
		},
		"correct": "b"
	},
	{
		"en": {
			"question": "What is the largest organ in the human body?",
			"options": ["Brain", "Heart", "Liver", "Skin"],
			"hint": "Hint: It covers and protects the body."
		},
		"hi": {
			"question": "मानव शरीर का सबसे बड़ा अंग कौन सा है?",
			"options": ["मस्तिष्क", "हृदय", "यकृत", "त्वचा"],
			"hint": "संकेत: यह शरीर को ढकता और सुरक्षा प्रदान करता है।"
		},
		"correct": "d"
	},
	{
		"en": {
			"question": "What gas do plants take in during photosynthesis?",
			"options": ["Oxygen", "Carbon Dioxide", "Nitrogen", "Hydrogen"],
			"hint": "Hint: This gas is used by plants to make food."
		},
		"hi": {
			"question": "पौधे प्रकाश संश्लेषण के दौरान किस गैस को ग्रहण करते हैं?",
			"options": ["ऑक्सीजन", "कार्बन डाइऑक्साइड", "नाइट्रोजन", "हाइड्रोजन"],
			"hint": "संकेत: इस गैस का उपयोग पौधे भोजन बनाने के लिए करते हैं।"
		},
		"correct": "b"
	},
	{
		"en": {
			"question": "What is the boiling point of water?",
			"options": ["90°C", "100°C", "110°C", "120°C"],
			"hint": "Hint: It's the point at which water turns into steam."
		},
		"hi": {
			"question": "पानी का उबालने का बिंदु क्या है?",
			"options": ["90°C", "100°C", "110°C", "120°C"],
			"hint": "संकेत: यह वह बिंदु है जब पानी भाप में बदल जाता है।"
		},
		"correct": "b"
	},
	{
		"en": {
			"question": "What is the chemical symbol for gold?",
			"options": ["Ag", "Au", "Pb", "Fe"],
			"hint": "Hint: It is a precious metal often used in jewelry."
		},
		"hi": {
			"question": "सोने का रासायनिक प्रतीक क्या है?",
			"options": ["Ag", "Au", "Pb", "Fe"],
			"hint": "संकेत: यह एक कीमती धातु है जिसे अक्सर आभूषणों में प्रयोग किया जाता है।"
		},
		"correct": "b"
	},
	{
		"en": {
			"question": "What is the main function of red blood cells?",
			"options": ["Carry oxygen", "Fight infections", "Clot blood", "Digest food"],
			"hint": "Hint: These cells are responsible for carrying oxygen throughout the body."
		},
		"hi": {
			"question": "लाल रक्त कणिकाओं का मुख्य कार्य क्या है?",
			"options": ["ऑक्सीजन ले जाना", "संक्रमण से लड़ना", "रक्त का थक्का बनाना", "खाना पचाना"],
			"hint": "संकेत: ये कोशिकाएं शरीर में ऑक्सीजन ले जाने के लिए जिम्मेदार हैं।"
		},
		"correct": "a"
	},
	{
		"en": {
			"question": "What type of animal is a dolphin?",
			"options": ["Fish", "Mammal", "Reptile", "Amphibian"],
			"hint": "Hint: This animal is known for its intelligence and social behavior."
		},
		"hi": {
			"question": "डॉल्फिन किस प्रकार का जानवर है?",
			"options": ["मछली", "स्तनपायी", "उभयचर", "सरीसृप"],
			"hint": "संकेत: यह जानवर अपनी बुद्धिमत्ता और सामाजिक व्यवहार के लिए जाना जाता है।"
		},
		"correct": "b"
	},
	{
		"en": {
			"question": "How many continents are there on Earth?",
			"options": ["5", "6", "7", "8"],
			"hint": "Hint: The correct number includes Antarctica."
		},
		"hi": {
			"question": "पृथ्वी पर कित महाद्वीप हैं?",
			"options": ["5", "6", "7", "8"],
			"hint": "संकेत: सही संख्या में अंटार्कटिका भी शामिल है।"
		},
		"correct": "c"
	},
	{
		"en": {
			"question": "Which element is most abundant in the Earth's crust?",
			"options": ["Iron", "Oxygen", "Silicon", "Aluminum"],
			"hint": "Hint: This element makes up about 25% of the Earth's crust."
		},
		"hi": {
			"question": "पृथ्वी की म्यान में सबसे अधिक पाया जाने वाला तत्व कौन सा है?",
			"options": ["लोहा", "ऑक्सीजन", "सिलिकॉन", "एल्युमिनियम"],
			"hint": "संकेत: यह तत्व पृथ्वी की म्यान का लगभग 25% बनाता है।"
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



