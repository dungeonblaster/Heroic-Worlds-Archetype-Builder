extends Node

## Game Manager
## Handles scoring, game state, and UI updates

signal score_changed(left_score: int, right_score: int)

var left_score: int = 0
var right_score: int = 0
var max_score: int = 11  # Ping pong games typically go to 11

@onready var score_label = get_node("../UI/ScoreLabel")

func _ready():
	update_score_display()

func score_point(is_left_player: bool):
	if is_left_player:
		left_score += 1
	else:
		right_score += 1
	
	update_score_display()
	score_changed.emit(left_score, right_score)
	
	# Check for game win
	if left_score >= max_score or right_score >= max_score:
		end_game()

func update_score_display():
	if score_label:
		score_label.text = "%d - %d" % [left_score, right_score]

func end_game():
	var winner = "Left Player" if left_score >= max_score else "Right Player"
	print("Game Over! %s wins!" % winner)
	# Reset scores for next game
	left_score = 0
	right_score = 0
	update_score_display()

func reset_game():
	left_score = 0
	right_score = 0
	update_score_display()
