extends CharacterBody2D

const GRAVITY = 980.0
var thrown = false

signal enemy_hit

func throw(force: Vector2):
	thrown = true
	velocity = force  # Use built-in 'velocity' of CharacterBody2D

func _physics_process(delta):
	if thrown:
		# Apply gravity
		velocity.y += GRAVITY * delta

		# Move with current velocity
		move_and_slide()

		# Check for collisions
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			
			if collider.is_in_group("zomby2"):
				print("Hit a zombie!")
				collider.queue_free()
				emit_signal("enemy_hit")
				if collider.has_method("take_damage"):
					collider.take_damage()
				explode()

			elif collider.is_in_group("ground"):
				print("Bomb hit the ground!")
				explode()

func explode():
	# Add your explosion logic here (animation, sound, area damage, etc.)
	print("BOOM!")
	queue_free()
