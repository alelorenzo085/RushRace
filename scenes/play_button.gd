extends Button

func _ready() -> void:
	pressed.connect(_play_button, 4)

# Change to main scene when 'play' is pressed
func _play_button():
	get_tree().change_scene_to_file("res://scenes/rush_race.tscn")
