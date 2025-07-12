extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -580.0
const GRAVITY = 980.0  # Adjust as needed based on game feel
const DROP_SPEED = 400.0  # Speed to move down when Shift is pressed
const DROP_TIME = 0.1  # Time (in seconds) before re-enabling collision


@onready var clothes_sprite: Sprite2D = $Clothes
@onready var hat_sprite: Sprite2D = $Hat


@onready var idle_sprite2d: Sprite2D = $Idle
@onready var jump_sprite2d: Sprite2D = $Jump
@onready var run_sprite2d: Sprite2D = $Run
@onready var shoot_sprite2d: Sprite2D = $Shoot
@onready var dead_sprite2d: Sprite2D = $Dead
@onready var enemy = get_parent().get_node("Enemy")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var arrow_scene = preload("res://scenes/play/Level_Container/level3/assets/Arrow.tscn")
@onready var bomb_scene = preload("res://scenes/play/same_assets_fro_all_level/Bomb.tscn")  # Replace with your bomb scene path
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var zomby3 =get_parent().get_node("Zomby3")
@onready var win_image = get_parent().get_parent().get_node("Victory")
@onready var lose_image = get_parent().get_parent().get_node("Defeat")
@onready var nail_trap = get_parent().get_node("NailTrap")
@onready var nail_trap2 = get_parent().get_node("NailTrap2")
@onready var nail_trap3 = get_parent().get_node("NailTrap3")

# for throw rope
@onready var rope_ray: RayCast2D = $RopeRayCast
@onready var rope_target_scene = preload("res://scenes/play/same_assets_fro_all_level/RopeTarget.tscn")

var rope_target: Node2D = null
var rope_connected := false


var is_shooting = false
var is_idling = false
var is_player_dead =false
var is_win = false
var has_bomb = false
var is_collect_bomb = true

var enemy_kill_count = 0
var total_enemy = 5  # 4 kill by arrow and one by bomb in level2

func _ready():
	if is_instance_valid(enemy):
		total_enemy = 1
		arrow_scene = preload("res://scenes/play/Level_Container/level2/assets/Arrow.tscn")
	if is_instance_valid(nail_trap):
		nail_trap.enemy_hit.connect(on_hit_by_zombie)
		nail_trap2.enemy_hit.connect(on_hit_by_zombie)
		total_enemy = 6
	if is_instance_valid(nail_trap3):
		nail_trap3.enemy_hit.connect(on_hit_by_zombie)
		total_enemy = 7
		
	load_customization()

func _physics_process(delta: float) -> void:
	# Apply gravity when not on the floor
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Handle horizontal movement
	var direction := Input.get_axis("move_left", "move_right")
	

	if is_on_floor():
		# Rope throw
		if Input.is_action_just_pressed("rope_throw") and not rope_connected:
			rope_ray.force_raycast_update()
			if rope_ray.is_colliding():
				var hit_point = rope_ray.get_collision_point()
				rope_target = rope_target_scene.instantiate()
				rope_target.position = hit_point
				#rope_target.position = self.position
				get_tree().current_scene.add_child(rope_target)
				rope_connected = true
				print("Rope connected at: ", hit_point)
		
		# Rope jump (if rope is attached)
		if rope_connected and Input.is_action_just_pressed("jump"):
			#var direction_to_rope = (rope_target.global_position - global_position).normalized()
			#velocity = direction_to_rope * 600  # Grapple pull speed
			velocity.y = JUMP_VELOCITY
			print("Grappling toward rope!")
			rope_connected = false
			if rope_target:
				rope_target.queue_free()
				rope_target = null
		elif Input.is_action_just_pressed("jump") :
			velocity.y = JUMP_VELOCITY+300
		
		
	## Reset rope when on floor
	#if is_on_floor() and rope_connected:
		#rope_connected = false
		#if rope_target:
			#rope_target.queue_free()
			#rope_target = null



	

	# Flip sprites
	if direction > 0:
		idle_sprite2d.flip_h = false
		run_sprite2d.flip_h = false
		jump_sprite2d.flip_h = false
		shoot_sprite2d.flip_h = false
		clothes_sprite.flip_h = false
		clothes_sprite.position = Vector2(-21,-11)
	elif direction < 0:
		idle_sprite2d.flip_h = true
		run_sprite2d.flip_h = true
		jump_sprite2d.flip_h = true
		shoot_sprite2d.flip_h = true
		clothes_sprite.flip_h = true
		clothes_sprite.position = Vector2(21,-11)

	## Handle scaling only for collision shape when jumping
	#var target_collision_scale := Vector2(1, 1)
	#if velocity.y < 0 and not is_on_floor():
		#target_collision_scale = Vector2(1, 0.5)
	#collision_shape.scale = collision_shape.scale.lerp(target_collision_scale, delta * 10)


	# Set animations and idle
	if not is_player_dead :
		if is_on_floor():
			if direction == 0:
				if not is_idling:
					start_idle_state()
			else:
				set_active_sprite(run_sprite2d)
				animation_player.play("Run")
				is_idling = false
				is_shooting = false
				if rope_connected:
					rope_connected = false
					if rope_target:
						rope_target.queue_free()
						rope_target = null
		else:
			set_active_sprite(jump_sprite2d)
			animation_player.play("jump")
			is_shooting = false

	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Shooting
	if Input.is_action_just_pressed("shoot") and not is_player_dead:
		is_shooting = true
		set_active_sprite(shoot_sprite2d)
		animation_player.play("Shoot")
	
	# Press Q to throw bomb
	if Input.is_action_just_pressed("throw_bomb") and has_bomb:
		throw_bomb()

	# Drop through platform logic
	if Input.is_action_just_pressed("shift_down") and is_colliding_with_group("ShiftDownPath"):
		set_collision_mask_value(6, false)
		velocity.y = DROP_SPEED
		await get_tree().create_timer(DROP_TIME).timeout
		set_collision_mask_value(6, true)
	if is_collect_bomb :
		check_bomb_collision()

func shoot_arrow():
	var arrow = arrow_scene.instantiate()
	arrow.position = position + Vector2(30, 0)
	arrow.direction = Vector2.RIGHT if not idle_sprite2d.flip_h else Vector2.LEFT
	if idle_sprite2d.flip_h:
		arrow.scale.x = -1
	get_parent().add_child(arrow)
	arrow.enemy_hit.connect(_on_arrow_enemy_hit)
	
	#play music
	ShootBgm.allow_music = true
	if not ShootBgm.player.playing:
		ShootBgm.player.play()

func is_colliding_with_group(group_name: String) -> bool:
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		if collision.get_collider().is_in_group(group_name):
			return true
	return false

func _on_arrow_enemy_hit():
	enemy_kill_count +=1
	print(enemy_kill_count)
	print(total_enemy)
	if enemy_kill_count == total_enemy :
		is_win = true
		print("You win!")
		VictoryBgm.allow_music = true
		if not VictoryBgm.player.playing:
			VictoryBgm.player.play()
		win_image.visible = true
		win_image.set_pivot_offset(win_image.size / 2)
		win_image.scale = Vector2.ZERO
		var tween = create_tween()
		tween.tween_property(win_image, "scale", Vector2(1, 1), 2.0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		get_parent().get_parent().get_node("OkButton").visible = true
		get_parent().visible = false


func set_active_sprite(active_sprite: Sprite2D) -> void:
	var all_sprites = [idle_sprite2d, jump_sprite2d, run_sprite2d, shoot_sprite2d, dead_sprite2d]
	for sprite in all_sprites:
		sprite.visible = (sprite == active_sprite)


func start_idle_state():
	is_idling = true
	if is_shooting:
		await get_tree().create_timer(1.0).timeout
		if is_shooting :
			shoot_arrow()
	if not is_shooting and is_on_floor() and Input.get_axis("move_left", "move_right") == 0:
		set_active_sprite(idle_sprite2d)
		animation_player.play("idle")
	is_idling = false
	is_shooting = false

func on_hit_by_zombie():
	if not is_win:
		is_shooting=false
		self.remove_from_group("player")
		if is_instance_valid(zomby3):
			zomby3.queue_free()

		#$CollisionShape2D.disabled = true
		is_player_dead = true
		print("Player hit by zombie!")
		
	
		# Ensure all other sprites are hidden, and only dead_sprite is visible
		set_active_sprite(dead_sprite2d)
		clothes_sprite.visible = false
		hat_sprite.visible=false
		animation_player.play("Dead")
	
		# Wait until animation finishes before doing anything else
		await animation_player.animation_finished
		if rope_connected:
			rope_connected = false
			if rope_target:
				rope_target.queue_free()
				rope_target = null
		
		#play music
		DefeatBgm.allow_music = true
		if not DefeatBgm.player.playing:
			DefeatBgm.player.play()
		
		# Now hide player and show defeat screen
		
		lose_image.visible = true
		lose_image.scale = Vector2.ZERO
		print("Lose image node:", lose_image)
	
		var tween = create_tween()
		tween.tween_property(lose_image, "scale", Vector2(1, 1), 2.0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		get_parent().get_parent().get_node("OkButton").visible = true
		
		get_parent().visible = false

func throw_bomb():
	var bomb = bomb_scene.instantiate()
	get_tree().current_scene.add_child(bomb)
	bomb.enemy_hit.connect(_on_arrow_enemy_hit)
	bomb.global_position = global_position
	var direction = Vector2(1, -0.5)
	if idle_sprite2d.flip_h:
		direction = Vector2(-1, -0.5)
	bomb.throw(direction.normalized())
	has_bomb = false
	
	await get_tree().create_timer(0.3).timeout  # Wait for 0.3 seconds
	is_collect_bomb = true  # Re-enable bomb collection

func check_bomb_collision():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision and collision.get_collider().is_in_group("bomb") and not has_bomb:
			has_bomb = true
			collision.get_collider().queue_free()
			print("Bomb collected!")
			is_collect_bomb = false


#--------- costumised player load----------
func load_customization():
	if not FileAccess.file_exists("user://player_customization.json"):
		print("No customization save found.")
		return

	var file = FileAccess.open("user://player_customization.json", FileAccess.READ)
	var content = file.get_as_text()
	file.close()

	var save_data = JSON.parse_string(content)
	if save_data == null:
		print("Failed to parse customization save.")
		return

	# All character sprites in a list
	var all_sprites = [idle_sprite2d, run_sprite2d, jump_sprite2d, shoot_sprite2d, dead_sprite2d]

	# Apply color to all sprites
	var color = Color.from_string(save_data.get("color", "#ffffff"), Color.WHITE)
	for sprite in all_sprites:
		sprite.modulate = color

	# Outfit logic
	var outfit_index = int(save_data.get("outfit_index", 0))
	if outfit_index == 0:
		clothes_sprite.visible = false
	elif outfit_index == 1:
		clothes_sprite.visible = true
		clothes_sprite.texture = load("res://dress/blue.png")
	elif outfit_index == 2:
		clothes_sprite.visible = true
		clothes_sprite.texture = load("res://dress/red.png")
	elif outfit_index == 3:
		clothes_sprite.visible = true
		clothes_sprite.texture = load("res://dress/white.png")
	elif outfit_index == 4:
		clothes_sprite.visible = true
		clothes_sprite.texture = load("res://dress/yellow.png")
	elif outfit_index == 5:
		clothes_sprite.visible = true
		clothes_sprite.texture = load("res://dress/dark_yellow.png")
	
	# Hat logic 
	var hat_index = int(save_data.get("hat_index", 0))

	if hat_index == 0:
		hat_sprite.visible = false
		print("Hat index 0: hidden")
	elif hat_index == 1:
		hat_sprite.visible = true
		hat_sprite.texture = load("res://hat/hat1.png")
		print("Hat index 1: hat1.png loaded")
	elif hat_index == 2:
		hat_sprite.visible = true
		hat_sprite.texture = load("res://hat/hat2.png")
		print("Hat index 2: hat2.png loaded")
	else:
		hat_sprite.visible = false
		print("Unknown hat index:", hat_index)

	print("Customization loaded into player.")
