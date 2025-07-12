extends Control

const GRID_SIZE := 4
const BOX_SIZE := 2

@onready var result_label = $ResultLabel
@onready var unlock_image = $UnlockImage

var puzzle = []
var cells: Array = []

func _ready():
	
	# Enable input on TextureRect
	unlock_image.mouse_filter = Control.MOUSE_FILTER_STOP
	unlock_image.gui_input.connect(_on_unlock_image_clicked)
	
	puzzle = [
		[1, 0, 0, 4],
		[0, 0, 2, 0],
		[0, 3, 0, 0],
		[2, 0, 0, 3]
	]
	create_board()
	populate_board()

func create_board():
	var board = $Board
	board.columns = GRID_SIZE
	cells.clear()

	for child in board.get_children():
		board.remove_child(child)
		child.queue_free()

	for row in range(GRID_SIZE):
		for col in range(GRID_SIZE):
			var cell = LineEdit.new()
			cell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			cell.size_flags_vertical = Control.SIZE_EXPAND_FILL
			#cell.horizontal_alignment = TextAlign.CENTER
			cell.max_length = 1
			cell.expand_to_text_length = false
			cell.custom_minimum_size = Vector2(50, 50)
			board.add_child(cell)
			cells.append(cell)

func populate_board():
	for row in range(GRID_SIZE):
		for col in range(GRID_SIZE):
			var index = row * GRID_SIZE + col
			var value = puzzle[row][col]
			var cell = cells[index]
			if value != 0:
				cell.text = str(value)
				cell.editable = false
				cell.add_theme_color_override("font_color", Color("blue"))
			else:
				cell.text = ""
				cell.editable = true

func get_user_input() -> Array:
	var user_grid: Array = []

	for row in range(GRID_SIZE):
		var row_data: Array = []
		for col in range(GRID_SIZE):
			var index = row * GRID_SIZE + col
			var cell: LineEdit = cells[index]
			var text: String = cell.text.strip_edges()

			if text.is_valid_int():
				var number = int(text)
				if number >= 1 and number <= GRID_SIZE:
					row_data.append(number)
				else:
					row_data.append(0)
			else:
				row_data.append(0)
		user_grid.append(row_data)

	return user_grid

func is_valid_move(grid: Array, row: int, col: int, num: int) -> bool:
	# Check row
	for i in range(GRID_SIZE):
		if i != col and grid[row][i] == num:
			return false

	# Check column
	for i in range(GRID_SIZE):
		if i != row and grid[i][col] == num:
			return false

	# Check box
	var box_row_start = row / BOX_SIZE * BOX_SIZE
	var box_col_start = col / BOX_SIZE * BOX_SIZE

	for i in range(BOX_SIZE):
		for j in range(BOX_SIZE):
			var r = box_row_start + i
			var c = box_col_start + j
			if (r != row or c != col) and grid[r][c] == num:
				return false

	return true

func is_board_complete_and_valid(grid: Array) -> bool:
	for row in range(GRID_SIZE):
		for col in range(GRID_SIZE):
			var num = grid[row][col]
			if num == 0 or not is_valid_move(grid, row, col, num):
				return false
	return true

func _on_check_button_pressed():
	var user_grid = get_user_input()

	if is_board_complete_and_valid(user_grid):
		GameState.unlock_level("level_4")
		result_label.text = "Correct solution! You've unlocked Level 4!"
		unlock_image.visible=true
		unlock_image.scale = Vector2.ZERO
		var tween = create_tween()
		tween.tween_property(unlock_image, "scale", Vector2(1, 1), 2.0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	else:
		result_label.text = " Something is wrong or incomplete."

func _on_unlock_image_clicked(event):
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to_file("res://scenes/play/Lavel_Container.tscn")
