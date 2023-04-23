extends Node2D

const Board = preload("res://scripts/board.gd")
const Score = preload("res://scripts/score.gd")

#game
var boarda: Board
var timer: Timer
var game_over: bool = false
var score: Score

func _ready():
	boarda = get_node("Board")
	timer = get_node("Timer")
	set_process_input(true)

func _input(event: InputEvent) -> void:
	# Move the Puyo pair left or right with the arrow keys
	if event is InputEventKey and not game_over:
		var direction = Vector2.ZERO
		if event.scancode == KEY_LEFT:
			direction.x -= 1
		elif event.scancode == KEY_RIGHT:
			direction.x += 1
		boarda.move_puyo(direction)

		# Rotate the Puyo pair with the up arrow key
		if event.scancode == KEY_UP:
			boarda.rotate_puyo
		elif event.scancode == KEY_DOWN:
			boarda.rotate_puyo

func _on_Timer_timeout() -> void:
	# Move the Puyo pair down at regular intervals
	if not game_over:
		if boarda.move_puyo(Vector2.DOWN):
			# If the Puyo pair cannot move down any further, add a new Puyo pair to the board
			boarda.add_puyo_pair()
			var chains = boarda.check_for_matches()
			if chains > 0:
				# If there are matching Puyo pairs, update the score and reset the timer
				score += chains * 13
				timer.start()
			else:
				# If there are no matching Puyo pairs, end the game
				game_over = true
				print("Game Over!")
