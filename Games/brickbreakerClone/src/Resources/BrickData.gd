extends Resource

class_name BrickData

@export var startingHitCount : int = 1
@export var baseScore : int = 5

var hitCount : int = 0

# Array of 6 colors (you can tweak these however you want)
@export var hitColors : Array[Color] = [
	Color(1, 0, 0),      # Red
	Color(1, 0.5, 0),    # Orange
	Color(1, 1, 0),      # Yellow
	Color(0, 1, 0),      # Green
	Color(0, 0, 1),      # Blue
	Color(0.5, 0, 1)     # Purple
]

# Returns a color based on current hit count
func get_color(currentHitCount: int) -> Color:
	if hitColors.is_empty():
		return Color.WHITE
	
	# Clamp index to valid range
	var index = clamp(currentHitCount - 1, 0, hitColors.size() - 1)
	return hitColors[index]


# Calculates final score
func get_final_score() -> int:
	return baseScore * startingHitCount
