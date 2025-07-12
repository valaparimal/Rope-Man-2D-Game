extends Control

func _ready() -> void:
	Global.load_player_data()
	
	$NameLabel.text = "Welcome, " + Global.player_name + "!"
	$AgeLabel.text = "Age: " + str(Global.player_age)
