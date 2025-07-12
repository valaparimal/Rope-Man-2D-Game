extends CharacterBody2D

const SPEED = 100.0
var direction = -1  # Start moving left

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ray_left: RayCast2D = $RayLeft
@onready var ray_right: RayCast2D = $RayRight
@onready var sprite = $Trap  # Make sure $Trap exists and is the right node

func _ready():
	animation_player.play("Rotate")

func _physics_process(delta):
	check_player_collision()
	if animation_player.current_animation != "Rotate" or not animation_player.is_playing():
		animation_player.play("Rotate")

	if ray_right.is_colliding():
		direction = -1
		#sprite.flip_h = true
	if ray_left.is_colliding():
		direction = 1
		#sprite.flip_h = false
	position.x += direction * SPEED * delta

	#velocity.x = direction * SPEED

	# Flip sprite visually
	sprite.flip_h = direction > 0

	move_and_slide()

func check_player_collision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider and collider.is_in_group("player"):
			if collider.has_method("on_hit_by_zombie"):
				collider.on_hit_by_zombie()
			break
