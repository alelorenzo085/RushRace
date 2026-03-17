extends Node2D

# Array of background music available tracks.
var music = [
	preload("res://2D/rush-race/resources/music/DavidKBD - Pink Bloom Pack - 05 - Western Cyberhorse.ogg"),
	preload("res://2D/rush-race/resources/music/DavidKBD - Pink Bloom Pack - 06 - Diamonds on The Ceiling.ogg")
]

# The car node.
@onready var _car: CharacterBody2D = $Car
# The audio stream player node to play the background music.
@onready var _audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
# The timer to spawn new obstacle cars.
@onready var _timer: Timer = $Timer
# The score label.
@onready var _score_label = $CanvasLayer/Score
var distance = 0
# The obstacle cars scene.
@onready var Obstacle := preload("res://2D/rush-race/obstacle/obstacle.tscn")

# Handles the background music and obstacle cars spawn timer.
func _ready() -> void:
	# Picks a random music track from the music array.
	_audio_stream_player.stream = music.pick_random()
	# Plays the music track.
	_audio_stream_player.play()

	# Sets the spawn timer timeout signal to a lambda function.
	_timer.timeout.connect(func() -> void:
		# Instantiates the obstacle car scene.
		var obstacle := Obstacle.instantiate()
		# Sets the obstacle car position to a random position ahead of the car
		# and inside of the road limits.
		obstacle.position = Vector2(_car.global_position.x + 1500, randi_range(180, 310))
		# Adds the obstacle car to the root scene.
		add_child(obstacle)
	)
func _process(delta):
	distance = int(_car.global_position.x / 10)
	_score_label.text = "Score: " + str(distance)
func _game_over():
	Global.score = get_parent().distance
	get_tree().change_scene_to_file("res://2D/rush-race/menus/GameOver.tscn")
	
