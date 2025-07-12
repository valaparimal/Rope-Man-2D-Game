extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -580.0
const GRAVITY = 980.0  # Adjust as needed based on game feel
const DROP_SPEED = 400.0  # Speed to move down when Shift is pressed
const DROP_TIME = 0.5  # Time (in seconds) before re-enabling collision


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var arrow_scene = preload("res://scenes/play/same_assets_fro_all_level/Arrow.tscn")  # Load the arrow scene
@onready var collision_shape: CollisionShape2D = $CollisionShape2D  # Correctly get the collision shape node
@onready var win_image = get_parent().get_parent().get_node("Victory")




func _physics_process(delta: float) -> void:
	# Apply gravity when not on the floor
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Handle jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY  # Jump impulse

	# Handle horizontal movement
	var direction := Input.get_axis("move_left", "move_right")

	if direction > 0:
		animated_sprite_2d.flip_h = true
	elif direction < 0:
		animated_sprite_2d.flip_h = false

	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("standing")
		else: 
			animated_sprite_2d.play("running")
	else:
		animated_sprite_2d.play("jumping")

	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	
	# Check for shooting
	if Input.is_action_just_pressed("shoot"):
		shoot_arrow()
		
	# Handle passing through ShiftDownPath group
	if Input.is_action_just_pressed("shift_down") and is_colliding_with_group("ShiftDownPath"):
		set_collision_mask_value(6, false)  # Remove mask 6
		velocity.y = DROP_SPEED  # Force player downward
		await get_tree().create_timer(DROP_TIME).timeout  # Wait for 0.5 seconds
		set_collision_mask_value(6, true)  # Re-enable mask 6

func shoot_arrow():
	var arrow = arrow_scene.instantiate()  # Create an arrow instance
	arrow.position = position + Vector2(30, 0)  # Adjust the spawn position
	arrow.direction = Vector2.RIGHT if  animated_sprite_2d.flip_h else Vector2.LEFT   # Set direction
	if not animated_sprite_2d.flip_h:
		arrow.scale.x = -1 
	get_parent().add_child(arrow)  # Add the arrow to the scene
	arrow.enemy_hit.connect(_on_arrow_enemy_hit)
	
	
func is_colliding_with_group(group_name: String) -> bool:
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		if collision.get_collider().is_in_group(group_name):
			return true
	return false

func _on_arrow_enemy_hit():
	
	#play music
	VictoryBgm.allow_music = true
	if not VictoryBgm.player.playing:
		VictoryBgm.player.play()
	
	#image
	win_image.visible = true
	get_parent().visible=false
	win_image.set_pivot_offset(win_image.size / 2)  # Center pivot
	win_image.scale = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(win_image, "scale", Vector2(1, 1), 2.0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	get_parent().get_parent().get_node("OkButton").visible = true


