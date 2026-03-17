extends Area2D

# Signal emitted when the obstacle collides with the player car.
signal hit_player

# The array of different obstacle car sprites.
var sprites := [
	preload("res://2D/rush-race/resources/obstacles/ambulance.png"),
	preload("res://2D/rush-race/resources/obstacles/buggy.png"),
	preload("res://2D/rush-race/resources/obstacles/bus.png"),
	preload("res://2D/rush-race/resources/obstacles/bus_school.png"),
	preload("res://2D/rush-race/resources/obstacles/firetruck.png"),
	preload("res://2D/rush-race/resources/obstacles/hotdog.png"),
	preload("res://2D/rush-race/resources/obstacles/police.png"),
	preload("res://2D/rush-race/resources/obstacles/sports_convertible.png"),
	preload("res://2D/rush-race/resources/obstacles/sports_red.png"),
	preload("res://2D/rush-race/resources/obstacles/suv.png"),
	preload("res://2D/rush-race/resources/obstacles/taxi.png"),
	preload("res://2D/rush-race/resources/obstacles/transport.png"),
	preload("res://2D/rush-race/resources/obstacles/truck.png"),
	preload("res://2D/rush-race/resources/obstacles/truckcabin.png"),
	preload("res://2D/rush-race/resources/obstacles/trucktank.png"),
	preload("res://2D/rush-race/resources/obstacles/vendor.png"),
	preload("res://2D/rush-race/resources/obstacles/vintage.png"),
]

# The obstacle car speed.
var speed := 0
## The minimum speed of the obstacle car.
@export var min_speed := 500
## The maximum speed of the obstacle car.
@export var max_speed := 1500

# The obstacle car sprite node.
@onready var _sprite_2d: Sprite2D = $Sprite2D
# The obstacle car collision shape node.
@onready var _collision_shape_2d: CollisionShape2D = $CollisionShape2D
# The screen visibility notifier node.
@onready var _visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

# Handles the obstacle car initial sprite, position and speed and sets the
# screen visibility notifier signal.
func _ready() -> void:
	# Picks a random sprite from the sprites array.
	_sprite_2d.texture = sprites.pick_random()
	# Sets the obstacle car collision shape to a new rectangle shape.
	_collision_shape_2d.shape = RectangleShape2D.new()
	# Adjusts the collision shape size to the sprite texture size.
	_collision_shape_2d.shape.extents = Vector2(_sprite_2d.texture.get_width() * 1.5, _sprite_2d.texture.get_height() / 3)
	# Sets the collision shape position to the bottom of the sprite.
	_collision_shape_2d.position.y = _sprite_2d.texture.get_height()
	# Sets the obstacle car speed randomly.
	speed = randi_range(min_speed, max_speed)
	
	# Sets the screen exited signal of the screen visibility notifier to remove
	# the obstacle car when it exits the screen.
	_visible_on_screen_notifier_2d.screen_exited.connect(func() -> void:
		queue_free()
	)

	# When the obstacle car collides with the player car, stops it and signals game over.
	# Connected once in _ready to avoid duplicate connections each frame.
	body_entered.connect(func(body: Node2D) -> void:
		body.velocity = Vector2.ZERO
		emit_signal("hit_player")
	)

# Handles the obstacle car movement.
func _physics_process(delta: float) -> void:
	position.x += speed * delta
