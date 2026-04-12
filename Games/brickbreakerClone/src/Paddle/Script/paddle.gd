extends CharacterBody2D

@export var move_speed: float = 400.0
@export var screen_width: float = 1152.0  # Match your game resolution width

func _physics_process(delta: float) -> void:
	var direction := 0
	
	if Input.is_action_pressed("move_left"):
		direction -= 1
	elif Input.is_action_pressed("move_right"):
		direction += 1
	
	# Apply horizontal movement only
	velocity.x = direction * move_speed
	velocity.y = 0
	
	move_and_slide()
	
	# Screen wrap logic
	if global_position.x < 0:
		global_position.x = screen_width
	elif global_position.x > screen_width:
		global_position.x = 0
