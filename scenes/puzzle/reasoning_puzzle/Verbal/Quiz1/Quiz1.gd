extends Control

var last_window_size = Vector2.ZERO
var language := "en"  # Default language

# List of bilingual science questions
var questions = [
	{
		"en": {
			"question": "A, C, E, G, ?",
			"options": ["H", "I", "J", "K"],
			
			"hint": "Look at the gap between letters.",
			"concept": "Letters increase by 2: A(1), C(3), E(5), G(7), I(9)."

		},
		"hi": {
			"question": "A, C, E, G, ?",
			"options": ["H", "I", "J", "K"],
			
			"hint": "अक्षरों के बीच के अंतर को देखें।",
			"concept": "हर बार 2 अक्षर छोड़ कर अगला अक्षर: A(1), C(3), E(5), G(7), I(9)।"

		},
		"correct": "b"
	},
	{
		"en": {
			"question": "3, 6, 12, 24, ?",
			"options": ["36", "48", "50", "60"],
			"hint": "Each number is multiplied by 2.",
			"concept": "Geometric progression."

		},
		"hi": {
			"question": "3, 6, 12, 24, ?",
			"options": ["36", "48", "50", "60"],
			"hint": "हर संख्या को 2 से गुणा किया गया है।",
			"concept": "गुणोत्तर श्रेणी।"

		},
		"correct": "b"
	},
	{
		"en": {
			"question": "Pen : Write :: Knife : ?",
			"options": ["Cut", "Sharp", "Food", "Metal"],
			"hint": "Think of the action associated with the object.",
			"concept": "Tool and its function."

		},
		"hi": {
			"question": "पेन : लिखना :: चाकू : ?",
			"options": ["काटना", "तेज़", "खाना", "धातु"],
			"hint": "वस्तु से जुड़े क्रिया के बारे में सोचें।",
			"concept": "उपकरण और उसका कार्य।"

		},
		"correct": "a"
	},
	{
		"en": {
			"question": "Fish : Swim :: Bird : ?",
			"options": ["Fly", "Cage", "Tree", "Eggs"],
			"hint": "What does a bird naturally do?",
			"concept": "Animal and movement."

		},
		"hi": {
			"question": "मछली : तैरना :: पक्षी : ?",
			"options": ["उड़ना", "पिंजरा", "पेड़", "अंडे"],
			"hint": "पक्षी क्या करता है?",
			"concept": "प्राणी और उसकी गति।"

		},
		"correct": "a"
	},
	{
		"en": {
			"question": "Car, Bus, Train, Rocket",
			"options": ["Rocket", "Bus", "Train", "Car"],
			"hint": "Think about the mode of transport.",
			"concept": "Rocket travels in space; others on land."


		},
		"hi": {
			"question": "कार, बस, ट्रेन, रॉकेट",
			"options": ["रॉकेट", "बस", "ट्रेन", "कार"],
			"hint": "यात्रा के तरीके को देखें।",
			"concept": "रॉकेट अंतरिक्ष में चलता है, अन्य भूमि पर।"
		},
		"correct": "a"
	},
	{
		"en": {
			"question": "A pen costs ₹15. How many pens can you buy with ₹90?",
			"options": ["4", "6", "7", "9"],
			"hint": "Divide total money by cost per pen.",
			"concept": "Division."
		},
		"hi": {
			"question": "एक पेन की कीमत ₹15 है। ₹90 में कितने पेन आएँगे?",
			"options": ["4", "6", "7", "9"],
			"hint": "कुल राशि को एक पेन की कीमत से भाग दें।",
			"concept": "भाग देना।"
		},
		"correct": "b"
	},
	{
		"en": {
			"question": "A man walks 2 km in 30 minutes. How far can he walk in 2 hours?",
		"options": ["4 km", "6 km", "8 km", "12 km"],
		"hint": "Find speed per half hour, then scale.",
		"concept": "Time-distance calculation."

		},
		"hi": {
			"question": "एक आदमी 30 मिनट में 2 किमी चलता है। 2 घंटे में कितनी दूरी तय करेगा?",
		"options": ["4 किमी", "6 किमी", "8 किमी", "12 किमी"],
		"hint": "हर आधे घंटे की दूरी निकालें, फिर गुणा करें।",
		"concept": "समय-दूरी गणना।"
		},
		"correct": "c"
	},
	{
		"en": {
			"question": "If APPLE is written as BQQMF, how is BALL written?",
			"options": ["CBMM", "CBLL", "CBMN", "CAKK"],
			"hint": "Each letter is shifted by +1.",
			"concept": "Simple substitution cipher."
		},
		"hi": {
			"question": "अगर APPLE को BQQMF लिखा जाए, तो BALL को कैसे लिखा जाएगा?",
			"options": ["CBMM", "CBLL", "CBMN", "CAKK"],
			"hint": "हर अक्षर को +1 करें।",
			"concept": "सरल कोडिंग।"
		},
		"correct": "a"
	},
	{
		"en": {
			"question": "If TREE = USFF, then LEAF = ?",
			"options": ["MFBG", "MFAG", "MFBG", "MFBC"],
			"answer": "MFBG",
			"hint": "Add +1 to each letter.",
			"concept": "Alphabet shifting."


		},
		"hi": {
			"question": "अगर TREE = USFF है, तो LEAF = ?",
			"options": ["MFBG", "MFAG", "MFBG", "MFBC"],
			"answer": "MFBG",
			"hint": "हर अक्षर में +1 करें।",
			"concept": "अक्षर स्थानांतरण।"
		},
		"correct": "a"
	},
	{
		"en": {
			"question": "Rina is the sister of Meena. Meena is the daughter of Ram. What is Rina to Ram?",
			"options": ["Sister", "Wife", "Daughter", "Aunt"],
			"hint": "Use family tree logic.",
			"concept": "Relationship tracing."

		},
		"hi": {
			"question": "रीना, मीना की बहन है। मीना, राम की बेटी है। तो रीना, राम की क्या हुई?",
			"options": ["बहन", "पत्नी", "बेटी", "चाची"],
			"hint": "परिवार की स्थिति समझें।",
			"concept": "रिश्तों की गणना।"
		},
		"correct": "c"
	},
	{
		"en": {
			"question": "A boy walks 4 m North, then 3 m East. Where is he now from his starting point?",
			"options": ["North-East", "South-East", "South-West", "North-West"],
			"answer": "North-East",
			"hint": "Combine directions to form compass angle.",
			"concept": "Use grid or diagram."
		},
		"hi": {
			"question": "एक लड़का 4 मीटर उत्तर चला, फिर 3 मीटर पूर्व। वह अब किस दिशा में है?",
		"options": ["उत्तर-पूर्व", "दक्षिण-पूर्व", "दक्षिण-पश्चिम", "उत्तर-पश्चिम"],
		"answer": "उत्तर-पूर्व",
		"hint": "दिशा को मिलाएं।",
		"concept": "दिशा बोध।"
		},
		"correct": "a"
	},
	{
		"en": {
			"question": "If 5 + 3 = 16, 6 + 4 = 20, then 2 + 7 = ?",
			"options": ["18", "16", "14", "12"],
			"answer": "18",
			"hint": "Add numbers, then multiply by 2.",
			"concept": "(a + b) × 2."
		},
		"hi": {
			"question": "अगर 5 + 3 = 16 और 6 + 4 = 20 है, तो 2 + 7 = ?",
			"options": ["18", "16", "14", "12"],
			"answer": "18",
			"hint": "(a + b) × 2 का प्रयोग करें।",
			"concept": "गणितीय ऑपरेशन।"
		},
		"correct": "a"
	},
	{
		"en": {
			"question": "Four people A, B, C, D are sitting in a circle. A is to the left of B, C is opposite A. Who is to the right of B?",
		"options": ["C", "D", "A", "Can't Say"],
		"answer": "D",
		"hint": "Draw the circle arrangement.",
		"concept": "Circular seating puzzle."
		},
		"hi": {
			"question": "चार लोग A, B, C, D एक वृत्त में बैठे हैं। A, B के बाएं है। C, A के सामने है। B के दाएं कौन है?",
		"options": ["C", "D", "A", "पता नहीं"],
		"answer": "D",
		"hint": "वृत्त बनाकर सोचें।",
		"concept": "सर्कुलर अरेंजमेंट।"
		},
		"correct": "b"
	},
	{
		"en": {
			"question": "2, 6, 12, 20, ?",
			"options": ["30", "28", "32", "26"],
			"answer": "30",
			"hint": "Add increasing even numbers.",
			"concept": "+4, +6, +8..."
		},
		"hi": {
			"question": "2, 6, 12, 20, ?",
			"options": ["30", "28", "32", "26"],
			"answer": "30",
			"hint": "हर बार बढ़ते हुए सम संख्याएँ जोड़ें।",
			"concept": "+4, +6, +8..."
		},
		"correct": "a"
	},
	{
		"en": {
			"question": "Arrange: Egg, Hen, Chick, Nest",
			"options": ["Nest, Egg, Chick, Hen", "Egg, Nest, Hen, Chick", "Egg, Hen, Nest, Chick", "Nest, Hen, Egg, Chick"],
			"answer": "Nest, Egg, Chick, Hen",
			"hint": "Think life cycle + sequence.",
			"concept": "Logical order of events."
		},
		"hi": {
			"question": "क्रम में लगाएँ: अंडा, मुर्गी, चूजा, घोंसला",
			"options": ["घोंसला, अंडा, चूजा, मुर्गी", "अंडा, घोंसला, मुर्गी, चूजा", "अंडा, मुर्गी, घोंसला, चूजा", "घोंसला, मुर्गी, अंडा, चूजा"],
			"answer": "घोंसला, अंडा, चूजा, मुर्गी",
			"hint": "जीवन चक्र और क्रम पर विचार करें।",
			"concept": "तार्किक अनुक्रम।"
		},
		"correct": "a"
	},
	{
		"en": {
			"question": "How many letters are there between D and M?",
			"options": ["10", "8", "9", "7"],
			"answer": "7",
			"hint": "Count letters excluding D and M.",
			"concept": "Alphabet order."
		},
		"hi": {
			"question": "D और M के बीच में कितने अक्षर हैं?",
			"options": ["7", "8", "9", "10"],
			"answer": "7",
			"hint": "D और M को छोड़कर गिनें।",
			"concept": "वर्णमाला क्रम।"
		},
		"correct": "b"
	},
	{
		"en": {
			"question": "Rose, Lily, Lotus, Mango",
			"options": ["Rose", "Lotus", "Mango", "Lily"],
			"hint": "Find the odd one.",
			"concept": "Others are flowers, Mango is a fruit."

		},
		"hi": {
			"question": "गुलाब, कुमुदिनी, कमल, आम",
			"options": ["गुलाब", "कमल", "आम", "कुमुदिनी"],
			"hint": "अलग वस्तु को पहचानें।",
			"concept": "तीनों फूल हैं, आम फल है।"

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
