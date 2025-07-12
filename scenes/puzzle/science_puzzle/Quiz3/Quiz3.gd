extends Control

var last_window_size = Vector2.ZERO
var language := "en"  # Default language

# List of bilingual science questions
var questions = [
	{
		"en": {
			"question": "What is the chemical symbol for water?",
			"options": ["H2O", "O2", "CO2", "HO2"],
			"hint": "Hint: It consists of two hydrogen atoms and one oxygen atom."
		},
		"hi": {
			"question": "पानी का रासायनिक प्रतीक क्या है?",
			"options": ["H2O", "O2", "CO2", "HO2"],
			"hint": "संकेत: इसमें दो हाइड्रोजन परमाणु और एक ऑक्सीजन परमाणु होता है।"
		},
		"correct": "a"
	},
	{
		"en": {
			"question": "Which planet is closest to the sun?",
			"options": ["Mercury", "Venus", "Earth", "Mars"],
			"hint": "Hint: It's the smallest planet in our solar system."
		},
		"hi": {
			"question": "सूर्य के सबसे करीब कौन सा ग्रह है?",
			"options": ["बुध", "शुक्र", "पृथ्वी", "मंगल"],
			"hint": "संकेत: यह हमारे सौरमंडल का सबसे छोटा ग्रह है।"
		},
		"correct": "a"
	},
	{
		"en": {
			"question": "Which vitamin is produced by the skin when exposed to sunlight?",
			"options": ["Vitamin A", "Vitamin B12", "Vitamin C", "Vitamin D"],
			"hint": "Hint: It's essential for bone health."
		},
		"hi": {
			"question": "कौन सा विटामिन सूरज की रोशनी में त्वचा द्वारा उत्पन्न होता है?",
			"options": ["विटामिन A", "विटामिन B12", "विटामिन C", "विटामिन D"],
			"hint": "संकेत: यह हड्डियों के स्वास्थ्य के लिए आवश्यक है।"
		},
		"correct": "d"
	},
	{
		"en": {
			"question": "Which gas do humans breathe in to survive?",
			"options": ["Oxygen", "Carbon Dioxide", "Nitrogen", "Helium"],
			"hint": "Hint: This gas is essential for respiration."
		},
		"hi": {
			"question": "मनुष्यों को जीवित रहने के लिए कौन सा गैस श्वास में लेना पड़ता है?",
			"options": ["ऑक्सीजन", "कार्बन डाइऑक्साइड", "नाइट्रोजन", "हेलियम"],
			"hint": "संकेत: यह गैस श्वसन के लिए आवश्यक है।"
		},
		"correct": "a"
	},
	{
		"en": {
			"question": "What is the largest mammal on Earth?",
			"options": ["African Elephant", "Blue Whale", "Giraffe", "White Rhinoceros"],
			"hint": "Hint: This mammal lives in the ocean."
		},
		"hi": {
			"question": "पृथ्वी पर सबसे बड़ा स्तनपायी कौन सा है?",
			"options": ["अफ्रीकी हाथी", "नीला व्हेल", "जिराफ", "सफेद गैंडा"],
			"hint": "संकेत: यह स्तनपायी महासागर में रहता है।"
		},
		"correct": "b"
	},
	{
		"en": {
			"question": "What is the hottest planet in our solar system?",
			"options": ["Venus", "Mercury", "Mars", "Jupiter"],
			"hint": "Hint: It's the second planet from the Sun."
		},
		"hi": {
			"question": "हमारे सौरमंडल का सबसे गर्म ग्रह कौन सा है?",
			"options": ["शुक्र", "बुध", "मंगल", "बृहस्पति"],
			"hint": "संकेत: यह सूर्य से दूसरा ग्रह है।"
		},
		"correct": "a"
	},
	{
		"en": {
			"question": "Which part of the plant conducts photosynthesis?",
			"options": ["Roots", "Stem", "Leaves", "Flowers"],
			"hint": "Hint: This part of the plant contains chlorophyll."
		},
		"hi": {
			"question": "पौधे का कौन सा हिस्सा प्रकाश संश्लेषण करता है?",
			"options": ["जड़ें", "तना", "पत्तियाँ", "फूल"],
			"hint": "संकेत: इस हिस्से में क्लोरोफिल पाया जाता है।"
		},
		"correct": "c"
	},
	{
		"en": {
			"question": "What is the primary function of the heart?",
			"options": ["Pump blood", "Digest food", "Filter waste", "Produce hormones"],
			"hint": "Hint: This organ is essential for circulatory system."
		},
		"hi": {
			"question": "हृदय का मुख्य कार्य क्या है?",
			"options": ["रक्त पंप करना", "खाना पचाना", "अपशिष्ट को छानना", "हार्मोन बनाना"],
			"hint": "संकेत: यह अंग परिसंचरण तंत्र के लिए आवश्यक है।"
		},
		"correct": "a"
	},
	{
		"en": {
			"question": "What is the smallest bone in the human body?",
			"options": ["Stapes", "Femur", "Tibia", "Radius"],
			"hint": "Hint: This bone is located in the ear."
		},
		"hi": {
			"question": "मानव शरीर का सबसे छोटा हड्डी कौन सा है?",
			"options": ["स्टेप्स", "फेमुर", "टिबिया", "रेडियस"],
			"hint": "संकेत: यह हड्डी कान में स्थित है।"
		},
		"correct": "a"
	},
	{
		"en": {
			"question": "Which of these is a non-renewable resource?",
			"options": ["Solar energy", "Wind energy", "Coal", "Hydroelectric power"],
			"hint": "Hint: This resource is formed over millions of years."
		},
		"hi": {
			"question": "इनमें से कौन सा गैर-नवीकरणीय संसाधन है?",
			"options": ["सौर ऊर्जा", "हवाओं की ऊर्जा", "कोयला", "जलविद्युत ऊर्जा"],
			"hint": "संकेत: यह संसाधन लाखों वर्षों में बनता है।"
		},
		"correct": "c"
	},
	{
		"en": {
			"question": "What is the center of an atom called?",
			"options": ["Electron", "Neutron", "Proton", "Nucleus"],
			"hint": "Hint: This part contains positively charged particles."
		},
		"hi": {
			"question": "परमाणु का केंद्र किसे कहते हैं?",
			"options": ["इलेक्ट्रॉन", "न्यूट्रॉन", "प्रोटॉन", "न्यूक्लियस"],
			"hint": "संकेत: इस हिस्से में सकारात्मक रूप से आवेशित कण होते हैं।"
		},
		"correct": "d"
	},
	{
		"en": {
			"question": "What is the largest ocean on Earth?",
			"options": ["Atlantic Ocean", "Indian Ocean", "Arctic Ocean", "Pacific Ocean"],
			"hint": "Hint: This ocean covers more than one-third of the Earth's surface."
		},
		"hi": {
			"question": "पृथ्वी का सबसे बड़ा महासागर कौन सा है?",
			"options": ["अटलांटिक महासागर", "भारतीय महासागर", "आर्कटिक महासागर", "प्रशांत महासागर"],
			"hint": "संकेत: यह महासागर पृथ्वी की सतह का एक तिहाई से अधिक हिस्सा कवर करता है।"
		},
		"correct": "d"
	},
	{
		"en": {
			"question": "Which of the following is a primary color?",
			"options": ["Green", "Yellow", "Purple", "Orange"],
			"hint": "Hint: This color cannot be made by mixing other colors."
		},
		"hi": {
			"question": "निम्नलिखित में से कौन सा प्राथमिक रंग है?",
			"options": ["हरा", "पीला", "बैंगनी", "नारंगी"],
			"hint": "संकेत: यह रंग अन्य रंगों को मिलाकर नहीं बनाया जा सकता है।"
		},
		"correct": "a"
	},
	{
		"en": {
			"question": "Which country is known as the Land of the Rising Sun?",
			"options": ["China", "Japan", "South Korea", "India"],
			"hint": "Hint: This country is located east of China."
		},
		"hi": {
			"question": "कौन सा देश 'उगते सूरज की भूमि' के नाम से जाना जाता है?",
			"options": ["चीन", "जापान", "दक्षिण कोरिया", "भारत"],
			"hint": "संकेत: यह देश चीन के पूर्व में स्थित है।"
		},
		"correct": "b" 
	},
	{
		"en": {
			"question": "What is the main function of the digestive system?",
			"options": ["Transport nutrients", "Digest food", "Circulate blood", "Regulate body temperature"],
			"hint": "Hint: This system breaks down food for nutrient absorption."
		},
		"hi": {
			"question": "पाचन तंत्र का मुख्य कार्य क्या है?",
			"options": ["पोषक तत्वों का परिवहन", "खाना पचना", "रक्त का परिसंचरण", "शरीर का तापमान नियंत्रित करना"],
			"hint": "संकेत: यह तंत्र पोषक तत्वों के अवशोषण के लिए भोजन को तोड़ता है।"
		},
		"correct": "b"
	},
	{
		"en": {
			"question": "What is the most common element in the Earth's atmosphere?",
			"options": ["Oxygen", "Carbon Dioxide", "Nitrogen", "Hydrogen"],
			"hint": "Hint: This element makes up around 78% of the atmosphere."
		},
		"hi": {
			"question": "पृथ्वी के वायुमंडल में सबसे सामान्य तत्व कौन सा है?",
			"options": ["ऑक्सीजन", "कार्बन डाइऑक्साइड", "नाइट्रोजन", "हाइड्रोजन"],
			"hint": "संकेत: यह तत्व वायुमंडल का लगभग 78% बनाता है।"
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



