extends Control

@onready var tutorial_image = $TextureRect  # Reference to TextureRect
@onready var next_button = $Button  # Reference to Next button

# Load tutorial images in order
var tutorial_images = [
	preload("res://assets/sprites/tutorial_page1.png"),
	preload("res://assets/sprites/tutorial_page2.png"),
	preload("res://assets/sprites/tutorial_page3.png"),
	preload("res://assets/sprites/tutorial_page4.png"),
	preload("res://assets/sprites/tutorial_page5.png") # Final step
]

var current_step = 0  # Track the current tutorial step

func _ready():
	
	next_button = get_node("Panel/NextButton")  # Adjust path if needed
	tutorial_image = get_node("Panel/TextureRect")  # Adjust if needed

	if not next_button:
		print("ERROR: Button not found!")
		return

	if not tutorial_image:
		print("ERROR: TextureRect not found!")
		return

	next_button.pressed.connect(_next_step)  # Connect button signal
	tutorial_image.texture = tutorial_images[current_step]  # Show first image

	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		var size = get_viewport().get_visible_rect().size
		DisplayServer.window_set_size(size)
		DisplayServer.window_set_min_size(size)
		DisplayServer.window_set_max_size(size)

func _process(_delta):
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_MAXIMIZED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			# Exit fullscreen and lock current window size
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _next_step():
	ButtonClickBgm.allow_music = true
	ButtonClickBgm.player.play()
	current_step += 1  # Move to the next image
	if current_step < tutorial_images.size():
		tutorial_image.texture = tutorial_images[current_step]  # Update texture
	else:
		print("Tutorial Completed! Loading Main Scene...")
		load_main_scene()  # Load the main game scene

func load_main_scene():
	get_tree().change_scene_to_file("res://scenes/home.tscn")  # Adjust path	
	
