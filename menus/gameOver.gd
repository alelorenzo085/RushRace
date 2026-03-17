extends Control

@onready var score_label = $CenterContainer/VBoxContainer/ScoreLabel

func _ready():
	score_label.text = "Score: " + str(Global.score) + " m"


func _on_retry_button_pressed():
	get_tree().change_scene_to_file("res://scenes/rush-race.tscn")


func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
