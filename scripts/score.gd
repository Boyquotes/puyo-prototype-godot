extends Node

const SCORE_INCREMENT = 13

var score = 0

func _ready():
	# Initialize the score display
	update_score()

func add_score():
	# Increment the score and update the display
	score += SCORE_INCREMENT
	update_score()

func update_score():
	# Update the score display
	var score_label = get_node("score_number")
	score_label.text = "score:" + str(score)
