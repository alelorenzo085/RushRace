extends CharacterBody2D

# The animated sprite node to handle car animation.
@onready var _animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
# The car engine sound.
@onready var _engine_sound: AudioStreamPlayer = $EngineSound

## The top speed that the car can achieve.
@export var max_speed := 1500.0
## How much speed per second is added when the player presses a movement key.
@export var acceleration := 1200.0
## How much speed per second is lost when the player releases all movement keys.
@export var deceleration := 100.0

# Handles car movement, animation and sound.
func _physics_process(delta: float) -> void:

	# Gets the input direction and handles the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	# The maximum velocity the car can go.
	var desired_velocity := Vector2(direction * max_speed, 0)
	# Avoids the car to move backwards.
	if desired_velocity.x < 0.0:
		desired_velocity.x = 0.0
	
	# Moves the car toward the maximum velocity smoothly when accelerating.
	if direction:
		velocity = velocity.move_toward(desired_velocity, acceleration * delta)
	# Moves the car toward zero velocity smoothly when decelerating.
	else:
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	
	# Sets the correct animation and sound depending on the car speed.
	if velocity.x < 50:
		# Sets the stop animation and stops the engine sound when the car stops.
		_animated_sprite_2d.play("stop")
		_engine_sound.stop()
	else:
		# Sets the run animation and starts the car engine when it's running.
		_animated_sprite_2d.play("run")
		_engine_sound.play()

	# Allows the car to steer only when it's running.
	if velocity.x > 0.0:
		# Gets the steering value from the input.
		var steering := Input.get_axis("move_up", "move_down")
		# Sets the steering speed.
		velocity.y = steering * velocity.x * 0.1
	
	# Sets the animation speed depending on the car speed.
	_animated_sprite_2d.speed_scale = velocity.x / max_speed
	
	# Limits the car position to the road boundaries.
	position.y = clamp(position.y, 180, 310)
	
	move_and_slide()
