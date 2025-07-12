extends Area2D


func _on_body_entered(body: Node2D) -> void:
	print("entered")
	if Input.is_action_just_pressed("shift"):
		print("here")
	

#func _input(event: InputEvent) -> void:
	#pass
	


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass # Replace with function body.
