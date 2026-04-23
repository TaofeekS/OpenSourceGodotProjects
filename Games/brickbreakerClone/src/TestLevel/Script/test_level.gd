extends Node2D

var finalScore = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for brick in $brickContainer.get_children():
		brick.connect("brickDestroyed",Callable(self,"updateScore"))
	pass # Replace with function body.


func updateScore(newScore):
	finalScore += newScore

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_paddle_game_started() -> void:
	$CanvasLayer/instructionLabel.hide()
