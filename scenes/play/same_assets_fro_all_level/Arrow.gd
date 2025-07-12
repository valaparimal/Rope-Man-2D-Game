extends CharacterBody2D

signal enemy_hit

@onready var arrow_sprite = $Arrow1

@export var speed: float = 600.0  # Arrow movement speed
var direction: Vector2 = Vector2.RIGHT
  # Default direction

func _physics_process(delta):
	# Move the arrow and check for collisions
	var collision = move_and_collide(direction * speed * delta)

	if collision:
		var collider = collision.get_collider()

		# Ignore collision with the player
		if collider.is_in_group("player"):
			return  

		# Check if the collider is an enemy (CharacterBody2D)
		if collider is CharacterBody2D and collider.is_in_group("enemy"):
			print("Arrow hit an enemy:", collider.name)
			load_blast()
			await get_tree().create_timer(0.1).timeout
			collider.get_parent().queue_free()  # Free the enemy
			queue_free()  # Free the arrow
			emit_signal("enemy_hit")
			
		elif collider is CharacterBody2D and collider.is_in_group("zomby2"):
			print("Arrow hit an enemy:", collider.name)
			load_blast()
			await get_tree().create_timer(0.1).timeout
			collider.queue_free()  # Free the enemy
			queue_free()  # Free the arrow
			emit_signal("enemy_hit")

		# Handle collision with solid objects (StaticBody2D, RigidBody2D)
		elif collider is CharacterBody2D or collider is StaticBody2D or collider is RigidBody2D:
			load_blast()
			await get_tree().create_timer(0.1).timeout
			print("Arrow hit a solid object:", collider.name)
			queue_free()  # Destroy the arrow



# Function to set direction when shot
func set_direction(new_direction: Vector2):
	direction = new_direction.normalized()

# blast image load
func load_blast():
	arrow_sprite.texture = load("res://assets/sprites/blast1.png")
	
	#play music
	Blast1Bgm.allow_music = true
	if not Blast1Bgm.player.playing:
		Blast1Bgm.player.play()
