extends CharacterBody2D

signal enemy_hit

@onready var animation_player = $AnimationPlayer

@export var speed: float = 0 
var direction: Vector2 = Vector2.ONE  # Default direction

func _physics_process(delta):
	# Move the arrow and check for collisions
	var collision = move_and_collide(direction * speed * delta)

	if collision:
		var collider = collision.get_collider()

		# Check if the collider is an enemy (CharacterBody2D)
		if collider is CharacterBody2D and collider.is_in_group("player"):
			animation_player.play("Nail")
			print("Arrow hit an enemy:", collider.name)
			#collider.get_parent().queue_free()  # Free the enemy
			#queue_free()  # Free the arrow
			emit_signal("enemy_hit")


# Function to set direction when shot
func set_direction(new_direction: Vector2):
	direction = new_direction.normalized()
