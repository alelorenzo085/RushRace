extends Node2D

# Array of background music available tracks.
var music = [
	preload("res://2D/rush-race/resources/music/DavidKBD - Pink Bloom Pack - 05 - Western Cyberhorse.ogg"),
	preload("res://2D/rush-race/resources/music/DavidKBD - Pink Bloom Pack - 06 - Diamonds on The Ceiling.ogg")
]

# Distance in world units where the finish line is placed.
const FINISH_LINE_X := 5000.0

# The car node.
@onready var _car: CharacterBody2D = $Car
# The audio stream player node to play the background music.
@onready var _audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
# The timer to spawn new obstacle cars.
@onready var _timer: Timer = $Timer
# The score label.
@onready var _score_label = $CanvasLayer/Score

var distance = 0
# Prevents _win/_game_over from being called more than once.
var _game_ended := false

# The obstacle cars scene.
@onready var Obstacle := preload("res://2D/rush-race/obstacle/obstacle.tscn")

# Handles the background music, obstacle spawner and finish line detection.
func _ready() -> void:
	# Picks a random music track from the music array.
	_audio_stream_player.stream = music.pick_random()
	_audio_stream_player.play()

	# Connect the finish line signal using get_node to ensure it's found.
	var finish_line = get_node("FinishLine")
	finish_line.body_entered.connect(func(body: Node2D) -> void:
		if body == _car:
			_win()
	)

	# Sets the spawn timer timeout signal to a lambda function.
	_timer.timeout.connect(func() -> void:
		if _game_ended:
			return
		var obstacle := Obstacle.instantiate()
		obstacle.position = Vector2(_car.global_position.x + 1500, randi_range(180, 310))
		add_child(obstacle)
		obstacle.hit_player.connect(_game_over)
	)

func _process(_delta):
	if _game_ended:
		return
	distance = int(_car.global_position.x / 10)
	var remaining = max(0, int((FINISH_LINE_X - _car.global_position.x) / 10))
	if remaining > 0:
		_score_label.text = "Score: " + str(distance) + " m  |  Meta: " + str(remaining) + " m"
	else:
		_score_label.text = "Score: " + str(distance) + " m"

func _game_over():
	if _game_ended:
		return
	_game_ended = true
	Global.score = distance
	get_tree().call_deferred("change_scene_to_file", "res://2D/rush-race/menus/GameOver.tscn")

func _win():
	if _game_ended:
		return
	_game_ended = true
	Global.score = distance
	get_tree().call_deferred("change_scene_to_file", "res://2D/rush-race/menus/Win.tscn")
