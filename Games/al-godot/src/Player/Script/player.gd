extends CharacterBody2D

@export var walkSpeed: float = 120.0
@export var runSpeed: float = 200.0

@export var dashSpeed: float = 400.0
@export var dashDuration: float = 0.2
@export var dashCooldown: float = 0.6

var isRunning: bool = false
var isDashing: bool = false
var canDash: bool = true

var lastMoved: Vector2 = Vector2(1, 0)
var dashDirection: Vector2 = Vector2.ZERO

@onready var animationTree: AnimationTree = $AnimationTree
@onready var stateMachine = animationTree.get("parameters/playback")

@onready var dashTimer: Timer = $DashTimer
@onready var dashCooldownTimer: Timer = $DashCooldownTimer


func _ready() -> void:
	animationTree.active = true
	
	dashTimer.wait_time = dashDuration
	dashTimer.one_shot = true
	
	dashCooldownTimer.wait_time = dashCooldown
	dashCooldownTimer.one_shot = true
	
	dashTimer.timeout.connect(_on_dash_timer_timeout)
	dashCooldownTimer.timeout.connect(_on_dash_cooldown_timer_timeout)


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("dash"):
		start_dash()
	
	if isDashing:
		velocity = dashDirection * dashSpeed
	else:
		var input_direction := _get_input_direction()
		
		isRunning = Input.is_action_pressed("run")
		var current_speed := runSpeed if isRunning else walkSpeed
		
		velocity = input_direction * current_speed
		
		if input_direction != Vector2.ZERO:
			lastMoved = input_direction
	
	handleAnimation()
	move_and_slide()


func start_dash() -> void:
	if not canDash:
		return
	
	if isDashing:
		return
	
	if lastMoved == Vector2.ZERO:
		return
	
	isDashing = true
	canDash = false
	dashDirection = lastMoved.normalized()
	
	dashTimer.start()


func handleAnimation() -> void:
	animationTree.set("parameters/idle/blend_position", lastMoved)
	animationTree.set("parameters/walk/blend_position", lastMoved)
	animationTree.set("parameters/run/blend_position", lastMoved)
	animationTree.set("parameters/dash/blend_position", lastMoved)
	
	if isDashing:
		stateMachine.travel("dash")
	elif velocity == Vector2.ZERO:
		stateMachine.travel("idle")
	elif isRunning:
		stateMachine.travel("run")
	else:
		stateMachine.travel("walk")


func _on_dash_timer_timeout() -> void:
	isDashing = false
	velocity = Vector2.ZERO
	dashCooldownTimer.start()


func _on_dash_cooldown_timer_timeout() -> void:
	canDash = true


func _get_input_direction() -> Vector2:
	var horizontal := 0
	var vertical := 0
	
	# Side axis has higher priority
	if Input.is_action_pressed("move_left"):
		horizontal = -1
	elif Input.is_action_pressed("move_right"):
		horizontal = 1
	elif Input.is_action_pressed("move_up"):
		vertical = -1
	elif Input.is_action_pressed("move_down"):
		vertical = 1
	
	return Vector2(horizontal, vertical)
