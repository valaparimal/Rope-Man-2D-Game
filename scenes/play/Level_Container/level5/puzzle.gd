extends Control

const GRID_SIZE = 4
const TILE_COUNT = GRID_SIZE * GRID_SIZE
const TILE_SIZE = Vector2(100, 100)
var image_path = "res://assets/child_friendly_image.png"


var tiles = []             # List of dictionaries with button and region
var correct_order = []     # Original order of tile regions
var selected_tile := -1    # -1 means no tile selected

@onready var tile_grid = $TileGrid
@onready var unlock_image = $UnlockImage
@onready var result_label = $ResultLabel

func _ready():
	
	# Enable input on TextureRect
	unlock_image.mouse_filter = Control.MOUSE_FILTER_STOP
	unlock_image.gui_input.connect(_on_unlock_image_clicked)
	
	tile_grid.columns = GRID_SIZE
	_load_and_slice_image(image_path)

	# Store correct order before shuffling
	for tile_data in tiles:
		correct_order.append(tile_data["region"])

	_shuffle_tiles()
	_display_tiles()

func _load_and_slice_image(path):
	var image_texture = load(path)
	var tile_index = 0

	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			var region = Rect2(Vector2(x * TILE_SIZE.x, y * TILE_SIZE.y), TILE_SIZE)
			var tile_tex = AtlasTexture.new()
			tile_tex.atlas = image_texture
			tile_tex.region = region

			var btn = TextureButton.new()
			btn.custom_minimum_size = TILE_SIZE
			btn.name = str(tile_index)  # For debugging
			btn.texture_normal = tile_tex

			var tile_data = {
				"button": btn,
				"region": region
			}
			tiles.append(tile_data)
			tile_index += 1

func _shuffle_tiles():
	tiles.shuffle()

func _display_tiles():
	# Remove buttons from grid (but not delete)
	for child in tile_grid.get_children():
		tile_grid.remove_child(child)

	for i in range(tiles.size()):
		var tile_data = tiles[i]
		var btn = tile_data["button"]

		# Refresh texture in case it's stale
		var tile_tex = AtlasTexture.new()
		tile_tex.atlas = load(image_path)
		tile_tex.region = tile_data["region"]
		btn.texture_normal = tile_tex

		# Highlight selected
		btn.modulate = Color(0.8, 0.8, 1.0) if i == selected_tile else Color(1, 1, 1)

		# Disconnect existing signals
		var connections = btn.pressed.get_connections()
		for conn in connections:
			btn.pressed.disconnect(conn.callable)

		# Reconnect with captured index
		btn.pressed.connect(_on_tile_button_pressed.bind(i))

		tile_grid.add_child(btn)

func _on_tile_button_pressed(index):
	_on_tile_pressed(index)

func _on_tile_pressed(index):
	if selected_tile == -1:
		selected_tile = index
	else:
		# Swap selected tiles
		var temp = tiles[selected_tile]
		tiles[selected_tile] = tiles[index]
		tiles[index] = temp

		selected_tile = -1
		_check_win()

	_display_tiles()

func _check_win():
	for i in range(TILE_COUNT):
		if tiles[i]["region"] != correct_order[i]:
			return
	#GameState.unlock_level("level_5")
	print("Correct solution! You've unlocked All Level!")
	result_label.text = "Correct solution! You've unlocked All Level!"
	#unlock_image.visible=true
	#unlock_image.scale = Vector2.ZERO
	#var tween = create_tween()
	#tween.tween_property(unlock_image, "scale", Vector2(1, 1), 2.0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_unlock_image_clicked(event):
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to_file("res://scenes/play/Lavel_Container.tscn")
