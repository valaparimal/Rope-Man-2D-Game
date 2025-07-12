extends CharacterBody2D

@onready var idle_sprite: Sprite2D = $Idle
@onready var attack_sprite: Sprite2D = $Attack
@onready var hit_sprite: Sprite2D = $Hit
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var cannonball_scene = preload("res://scenes/play/same_assets_fro_all_level/Cannonball.tscn")

const THROW_INTERVAL = 3.0  # seconds
const THROW_FORCE = 350

func _ready():
	play_animation("Idle")

	var timer = Timer.new()
	timer.wait_time = THROW_INTERVAL
	timer.one_shot = false
	timer.autostart = true
	add_child(timer)
	timer.timeout.connect(_on_throw_cannonball)

func play_animation(anim_name: String):
	idle_sprite.visible = (anim_name == "Idle")
	attack_sprite.visible = (anim_name == "Attack")
	hit_sprite.visible = (anim_name == "Hit")

	if anim.has_animation(anim_name):
		anim.play(anim_name)
	else:
		print("Animation not found:", anim_name)

func _on_throw_cannonball():
	play_animation("Attack")

	var cannonball = cannonball_scene.instantiate()
	get_parent().add_child(cannonball)
	
	# Adjust position if needed
	cannonball.global_position = global_position + Vector2(-30, 0)

	# Fixed direction throw (left + slight upward angle)
	var direction = Vector2(-1, 0).normalized()

	if cannonball.has_method("throw"):
		cannonball.throw(direction * THROW_FORCE)
	else:
		print("Cannonball is missing 'throw()' method!")

	await get_tree().create_timer(0.5).timeout
	play_animation("Idle")
