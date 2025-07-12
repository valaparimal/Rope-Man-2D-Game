extends Area2D

signal player_death

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") :
		print("you died")
		Engine.time_scale = 0.5
		body.get_node("CollisionShape2D").queue_free()
		timer.start()
	

func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	emit_signal("player_death")
