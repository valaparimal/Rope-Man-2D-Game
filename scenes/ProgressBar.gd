extends ProgressBar

var counter = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	self.value=0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if counter == 100 :
		await (get_tree().create_timer(1)).timeout
		self.value = counter
		await (get_tree().create_timer(0.5)).timeout
		get_tree().change_scene_to_file("res://scenes/home.tscn")  # Replace with your actual root scene path
	self.value = counter
	counter += 1;
