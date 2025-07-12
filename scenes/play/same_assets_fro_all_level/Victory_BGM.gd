extends Node2D


@onready var player = $AudioStreamPlayer

var allow_music = false

func _ready():
	if allow_music and not player.playing:
		player.play()
	else:
		player.stop()
