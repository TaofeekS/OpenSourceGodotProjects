extends CharacterBody2D

signal gameStarted

@export var move_speed: float = 400.0
@export var screen_width: float = 1152.0
@export var launch_strength: float = 500.0

@onready var ball: RigidBody2D = $ball
var defualtYpos

var ball_attached: bool = true

func _ready() -> void:
	defualtYpos = position.y

func _physics_process(delta: float) -> void:
	var direction := 0

	if Input.is_action_pressed("move_left"):
		direction -= 1
	elif Input.is_action_pressed("move_right"):
		direction += 1

	velocity.x = direction * move_speed
	velocity.y = 0

	move_and_slide()

	# Screen wrap logic
	if global_position.x < 0:
		global_position.x = screen_width
	elif global_position.x > screen_width:
		global_position.x = 0

	if ball_attached and Input.is_action_just_pressed("fire"):
		launch_ball()
		emit_signal("gameStarted")
	
	if position.y != defualtYpos:
		position.y = defualtYpos


func launch_ball() -> void:
	if ball == null:
		return

	ball_attached = false

	# Store current global transform before reparenting
	var ball_global_position := ball.global_position

	# Remove from paddle and add to paddle's parent
	remove_child(ball)
	get_parent().add_child(ball)

	# Restore world position
	ball.global_position = ball_global_position

	# Make sure physics wakes up
	ball.freeze = false
	ball.sleeping = false

	# Random upward angle between -60 and 60 degrees
	# Negative Y is upward in Godot 2D
	var angle_deg := randf_range(-60.0, 60.0)
	var direction := Vector2.UP.rotated(deg_to_rad(angle_deg)).normalized()

	# Launch the ball
	ball.linear_velocity = Vector2.ZERO
	ball.apply_central_impulse(direction * launch_strength)
