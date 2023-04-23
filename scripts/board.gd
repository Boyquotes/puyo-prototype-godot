extends Node2D

const ROWS = 6
const COLUMNS = 12
const WIDTH = 32
const HEIGHT = 32

var board: Array = []
var puyo_fall_speed: float = 1
var puyo_group: PackedScene

class boarda:
	# Define the public class property
	const EMPTY = -1

	# Define the constructor
	func __init__(size: Vector2):
		pass
	
	# Define the set_cell method
	func set_cell(x: int, y: int, value: int):
		pass
	
	# Define the get_cell method
	func get_cell(x: int, y: int) -> int: 
		pass
	
	# Define the is_cell_empty method
	func is_cell_empty(x: int, y: int) -> bool: 
		pass

func _ready():
	puyo_group = load("res://main/puyo.tscn")
	# Initialize the board with empty spaces
	for row in range(ROWS):
		board.append([])
		for column in range(COLUMNS):
			board[row].append(null)

func add_puyo(row: int, column: int) -> void:
	# Create a new Puyo and add it to the board
	var puyo = puyo_group.instance()
	puyo.position = Vector2(column * WIDTH, row * HEIGHT)
	add_child(puyo)
	board[row][column] = puyo

func can_move_down(row: int, column: int) -> bool:
	# Check if a Puyo can move down
	if row == ROWS - 1:
		return false
	elif board[row + 1][column] != null:
		return false
	else:
		return true

func move_puyo_down(row: int, column: int) -> void:
	# Move a Puyo down one row
	var puyo = board[row][column]
	board[row][column] = null
	board[row + 1][column] = puyo
	puyo.position += Vector2(0, HEIGHT)

func check_for_matches() -> int:
	# Check for and remove matching Puyo pairs
	var chains = 0
	for row in range(ROWS):
		for column in range(COLUMNS):
			if board[row][column] != null:
				var puyo = board[row][column]
				var color = puyo.color
				var matches = get_matches(row, column, color, [])
				if matches.size() >= 4:
					chains += 1
					remove_matches(matches)
	return chains

func get_matches(row: int, column: int, color: String, matches: Array) -> Array:
	# Recursively check for matching Puyo pairs
	if board[row][column] != null and board[row][column].color == color and not matches.find(board[row][column]):
		matches.append(board[row][column])
		if row > 0:
			matches = get_matches(row - 1, column, color, matches)
		if row < ROWS - 1:
			matches = get_matches(row + 1, column, color, matches)
		if column > 0:
			matches = get_matches(row, column - 1, color, matches)
		if column < COLUMNS - 1:
			matches = get_matches(row, column + 1, color, matches)
	return matches

func remove_matches(matches: Array) -> void:
	# Remove matching Puyo pairs from the board
	for match in matches:
		for puyo in match:
			if not Board.is_valid_position(x, y) or board.get_cell(x, y) != Board.EMPTY:
				if puyo.falling:
					puyo.stop_falling()
					if puyo.y <= 0:
						game_over()
					else:
						board.set_cell(puyo.x, puyo.y, puyo.color)
	score += 13

	# Shift the remaining Puyo pairs down to fill in the gaps
	for x in range(boarda.width):
					for y in range(boarda.height - 1, -1, -1):
						if boarda.get_cell(x, y) == boarda.EMPTY:
							var above = y - 1
					while above >= 0:
						if boarda.get_cell(x, above) != boarda.EMPTY():
							boarda.set_cell(x, y, boarda.get_cell(x, above))
							boarda.set_cell(x, above, boarda.EMPTY)
							break
							above -= 1

	# Check for additional matches
	var new_matches = boarda.check_for_matches()
	if new_matches.size() > 0:
			remove_matches(new_matches)
	else:
			boarda.active_puyo_pair = null
			boarda.add_puyo_pair()
	var chains = board.check_for_matches()
	if chains > 0:
		score += chains * 13
		func ready():
			timer.start()
