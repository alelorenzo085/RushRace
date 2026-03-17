extends Control

@onready var score_label = $CenterContainer/VBoxContainer/ScoreLbl

func _ready():
	score_label.text = "Score: " + str(Global.score) + " m"


func _on_retry_button_pressed():
	get_tree().change_scene_to_file("res://2D/rush-race/rush-race.tscn")


func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://2D/rush-race/menus/MainMenu.tscn")
