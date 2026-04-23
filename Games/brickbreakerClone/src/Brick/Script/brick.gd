extends CharacterBody2D

signal brickDestroyed
@export var brickData : BrickData
@onready var colorRect : ColorRect = $ColorRect

var currentHitCount : int = 0


func _ready() -> void:
	if brickData == null:
		push_warning("BrickData is not assigned.")
		return
	
	currentHitCount = brickData.startingHitCount
	update_color()


func takeDamage(damage: int) -> void:
	if brickData == null:
		return
	
	currentHitCount -= damage
	
	if currentHitCount <= 0:
		emit_signal("brickDestroyed",brickData.get_final_score())
		queue_free()
		
		return
	
	update_color()


func update_color() -> void:
	if brickData == null:
		return
	
	var newColor : Color = brickData.get_color(currentHitCount)
	colorRect.color = newColor
