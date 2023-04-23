extends Sprite

const COLORS = ["red", "green", "blue", "yellow", "purple"]
const WIDTH = 32
const HEIGHT = 32

var color: String

func _ready():
	# Choose a random color for the Puyo
	color = COLORS[randi() % COLORS.size()]
	set_texture(load("res://ui/puyo/" + color + ".png"))

func get_width() -> int:
	return WIDTH

func get_height() -> int:
	return HEIGHT
