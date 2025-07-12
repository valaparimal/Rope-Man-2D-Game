extends CharacterBody2D

const GRAVITY = 0
var thrown = false

func throw(force: Vector2):
	thrown = true
	velocity = force  # Built-in property

func _physics_process(delta):
	if thrown:
		velocity.y += GRAVITY * delta
	move_and_slide()

	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		if collider.is_in_group("player"):
			print("Cannonball hit player!")
			if collider.has_method("on_hit_by_zombie"):
				collider.on_hit_by_zombie()
			break  # Stop checking more collisions after hitting player
		elif collider.is_in_group("arrow"):
			print("Cannonball hit arrow!")
			collider.queue_free()
			self.queue_free()
			break
		elif collider.is_in_group("path"):
			print("Cannonball hit path!")
			self.queue_free()
			break
