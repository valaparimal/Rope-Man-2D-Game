extends Node2D


@onready var player = $AudioStreamPlayer  

var allow_music = false

func _ready():
	var music_stream = load("res://assets/Music/HomeBgMusic.mp3")
	music_stream.loop = true
	if allow_music and not player.playing:
		player.play()
	else:
		player.stop()
