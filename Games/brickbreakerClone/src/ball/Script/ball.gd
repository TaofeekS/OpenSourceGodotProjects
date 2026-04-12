extends RigidBody2D

@export var speed: float = 500.0

func _ready() -> void:
	freeze = true


var min_y := 0.3  # tweak between 0.2 - 0.5

func _physics_process(delta: float) -> void:
	if freeze:
		return
	
	if linear_velocity.length() == 0:
		return
	
	var dir := linear_velocity.normalized()
	
	# Prevent too flat movement
	if abs(dir.y) < min_y:
		dir.y = sign(dir.y) * min_y
		dir = dir.normalized()
	
	linear_velocity = dir * speed
