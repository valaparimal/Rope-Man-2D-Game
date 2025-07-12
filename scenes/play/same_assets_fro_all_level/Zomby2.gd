extends CharacterBody2D

const SPEED = 40.0

@onready var idle_sprite: Sprite2D = $Idle
@onready var run_sprite: Sprite2D = $Run
@onready var attack_sprite: Sprite2D = $Attack3
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var direction := 1  # Start moving left
var is_attacking := false

func _physics_process(delta: float) -> void:
	if is_attacking:
		velocity.x = 0
		move_and_slide()
		return

	# Move zombie
	#velocity.x = direction * SPEED
	move_and_slide()

	# Flip sprites based on direction
	#idle_sprite.flip_h = direction < 0
	#run_sprite.flip_h = direction < 0
	attack_sprite.flip_h = direction < 0

	# Play animation
	if abs(velocity.x) > 1:
		#set_active_sprite(run_sprite)
		#animation_player.play("Run")
		pass
	else:
		set_active_sprite(idle_sprite)
		animation_player.play("Idle")

	# Check collision
	check_player_collision()

func set_active_sprite(active_sprite: Sprite2D) -> void:
	var all_sprites = [idle_sprite, run_sprite, attack_sprite]
	for sprite in all_sprites:
		sprite.visible = sprite == active_sprite

func check_player_collision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider and collider.is_in_group("player") and not is_attacking:
			if collider.has_method("on_hit_by_zombie"):
				collider.on_hit_by_zombie()
			start_attack()
			break

func start_attack():
	is_attacking = true
	set_active_sprite(attack_sprite)
	animation_player.play("Attack3")
	await animation_player.animation_finished
	#is_attacking = false
