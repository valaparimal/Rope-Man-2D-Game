extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body: Node):
	print("collect")
	if body.is_in_group("player"):  # Check if the colliding object is the player
		queue_free()  # Delete the gem
