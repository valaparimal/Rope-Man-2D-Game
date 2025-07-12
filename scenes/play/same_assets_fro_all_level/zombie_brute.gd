extends Node2D

@onready var lose_image = get_parent().get_parent().get_node("Defeat")

const SPEED = 40
var direction = 1
# Called when the node enters the scene tree for the first time.
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var kill_zone = $KillZone

func _ready():
	kill_zone.player_death.connect(_on_player_detected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	position.x += direction * SPEED * delta

func _on_player_detected():
	#play music
	DefeatBgm.allow_music = true
	if not DefeatBgm.player.playing:
		DefeatBgm.player.play()
		
	print("Zombie Brute: Player detected by child!")
	lose_image.visible = true
	lose_image.set_pivot_offset(lose_image.size / 2)  # Center pivot
	get_parent().visible=false
	lose_image.scale = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(lose_image, "scale", Vector2(1, 1), 2.0).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	get_parent().get_parent().get_node("OkButton").visible = true

