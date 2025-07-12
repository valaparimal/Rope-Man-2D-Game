extends Control

const NONOGRAM_SIZE = 5

@onready var result_label = $ResultLabel
@onready var unlock_image = $UnlockImage

var nonogram_solution = [
	[false, true,  false, false, false],
	[true,  true,  true,  false, false],
	[false, true,  false, true,  false],
	[true,  true,  true,  true,  true],
	[false, true,  false, false, false]
]

var nonogram_cells = []

func _ready():
	# Enable input on TextureRect
	unlock_image.mouse_filter = Control.MOUSE_FILTER_STOP
	unlock_image.gui_input.connect(_on_unlock_image_clicked)
	
	_init_nonogram_grid()
	_populate_nonogram_clues()
	$CheckButton.pressed.connect(_check_nonogram_solution)

func _init_nonogram_grid():
	var grid = $Grid
	grid.columns = NONOGRAM_SIZE
	nonogram_cells.clear()
	for row in range(NONOGRAM_SIZE):
		for col in range(NONOGRAM_SIZE):
			var button = Button.new()
			button.toggle_mode = true
			button.text = ""
			button.custom_minimum_size = Vector2(40, 40)
			grid.add_child(button)
			nonogram_cells.append(button)

func _populate_nonogram_clues():
	var row_data = [
		[1],
		[3],
		[1, 1],
		[5],
		[1]
	]
	for clue in row_data:
		var label = Label.new()
		label.text = str(clue)
		$RowClues.add_child(label)

	var col_data = [
		[1, 1],
		[5],
		[1, 1],
		[2],
		[1]
	]

	for clue in col_data:
		var label = Label.new()
		label.text = str(clue)
		$ColumnClues.add_child(label)

func _check_nonogram_solution():
	var is_correct = true
	for row in range(NONOGRAM_SIZE):
		for col in range(NONOGRAM_SIZE):
			var index = row * NONOGRAM_SIZE + col
			var expected = nonogram_solution[row][col]
			var actual = nonogram_cells[index].button_pressed
			if expected != actual:
				is_correct = false
				nonogram_cells[index].add_theme_color_override("font_color", Color.RED)
			else:
				nonogram_cells[index].add_theme_color_override("font_color", Color.GREEN)

	if is_correct:
		#result_label.text = "Puzzle solved!"
		#print("Puzzle solved!")
		GameState.unlock_level("level_5")
		result_label.text = "Correct solution! You've unlocked Level 5!"
		unlock_image.visible=true
		unlock_image.scale = Vector2.ZERO
		var tween = create_tween()
		tween.tween_property(unlock_image, "scale", Vector2(1, 1), 2.0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	else:
		result_label.text = "Some tiles are incorrect."
		#print("Some tiles are incorrect.")

func _on_unlock_image_clicked(event):
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to_file("res://scenes/play/Lavel_Container.tscn")
