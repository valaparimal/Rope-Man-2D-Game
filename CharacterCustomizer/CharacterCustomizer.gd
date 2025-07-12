extends Node2D

@onready var base_sprite = $BaseSprite
@onready var clothes_sprite = $ClothesSprite
@onready var hat_sprite = $HatSprite
@onready var effects_sprite = $EffectsSprite

@onready var clothes_color_picker = $ClothesColorPicker
@onready var outfit_select = $OutfitSelect
@onready var hat_select = $HatSelect
@onready var save_button = $SaveButton
#@onready var load_button = $CanvasLayer/LoadButton

var current_direction = 0
var directions = ["front", "front_right", "right", "back_right", "back", "back_left", "left", "front_left"]

func _ready():
	#rotate_left_button.pressed.connect(_on_rotate_left)
	#rotate_right_button.pressed.connect(_on_rotate_right)
	clothes_color_picker.color_changed.connect(_on_clothes_color_changed)
	outfit_select.item_selected.connect(_on_outfit_selected)
	hat_select.item_selected.connect(_on_hat_selected)
	save_button.pressed.connect(_on_save_pressed)
	#load_button.pressed.connect(_on_load_pressed)

	#update_character_direction()
	_load_outfits()
	_load_hats()
	_on_load_pressed()

#func _on_rotate_left():
	#current_direction = (current_direction - 1) % directions.size()
	#update_character_direction()
#
#func _on_rotate_right():
	#current_direction = (current_direction + 1) % directions.size()
	#update_character_direction()
#
#func update_character_direction():
	#var dir = directions[current_direction]
	#var flip = dir in ["left", "back_left", "front_left"]
#
	#clothes_sprite.texture = load("res://sprites/clothes/shirt_default.png")
	#hat_sprite.texture = load("res://sprites/hats/hat_default.png")
#
	#base_sprite.flip_h = flip
	#clothes_sprite.flip_h = flip
	#hat_sprite.flip_h = flip
	#effects_sprite.flip_h = flip
#
	#if dir == "back" or dir == "front":
		#base_sprite.rotation_degrees = 0
	#else:
		#base_sprite.rotation_degrees = -5 if flip else 5

func _on_clothes_color_changed(color):
	base_sprite.modulate = color

func _load_outfits():
	outfit_select.clear()
	outfit_select.add_item("None")
	outfit_select.add_item("Blue")
	outfit_select.add_item("Red")
	outfit_select.add_item("White")
	outfit_select.add_item("Yellow")
	outfit_select.add_item("Dark Yellow")

func _on_outfit_selected(index):
	match outfit_select.get_item_text(index):
		"None":
			clothes_sprite.visible = false
		"Blue":
			clothes_sprite.visible = true
			clothes_sprite.texture = load("res://dress/blue.png")
		"Red":
			clothes_sprite.visible = true
			clothes_sprite.texture = load("res://dress/red.png")
		"White":
			clothes_sprite.visible = true
			clothes_sprite.texture = load("res://dress/white.png")
		"Yellow":
			clothes_sprite.visible = true
			clothes_sprite.texture = load("res://dress/yellow.png")
		"Dark Yellow":
			clothes_sprite.visible = true
			clothes_sprite.texture = load("res://dress/dark_yellow.png")

func _load_hats():
	hat_select.clear()
	hat_select.add_item("None")
	hat_select.add_item("Wizard Hat")
	hat_select.add_item("Bandana")

func _on_hat_selected(index):
	match hat_select.get_item_text(index):
		"None":
			hat_sprite.visible = false
		"Wizard Hat":
			hat_sprite.visible = true
			hat_sprite.texture = load("res://hat/hat1.png")
			hat_sprite.flip_h = true
		"Bandana":
			hat_sprite.visible = true
			hat_sprite.texture = load("res://hat/hat2.png")

# Save only: color tint, outfit index, hat index
func _on_save_pressed():
	var save_data = {
		"color": base_sprite.modulate.to_html(),
		"outfit_index": outfit_select.selected,
		"hat_index": hat_select.selected
	}
	var file = FileAccess.open("user://player_customization.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()
	print("Player customization saved.")
	
	get_tree().change_scene_to_file("res://scenes/Loading.tscn")  # Replace with your actual root scene path
	

# Load and restore values
func _on_load_pressed():
	if not FileAccess.file_exists("user://player_customization.json"):
		print("No save file found.")
		return

	var file = FileAccess.open("user://player_customization.json", FileAccess.READ)
	var content = file.get_as_text()
	file.close()

	var save_data = JSON.parse_string(content)
	if save_data == null:
		print("Failed to parse save file.")
		return

	var color = Color.from_string(save_data["color"], Color.WHITE)

	base_sprite.modulate = color
	clothes_color_picker.color = color # Update UI color picker

	outfit_select.select(save_data["outfit_index"])
	_on_outfit_selected(save_data["outfit_index"])

	hat_select.select(save_data["hat_index"])
	_on_hat_selected(save_data["hat_index"])

	print("Player customization loaded.")


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/home.tscn")  # Replace with your actual root scene path
