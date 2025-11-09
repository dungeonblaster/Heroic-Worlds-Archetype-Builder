extends Node2D

@onready var player1_score_label = $UI/Player1Score
@onready var player2_score_label = $UI/Player2Score
@onready var center_line = $CenterLine
@onready var ball = $Ball

var player1_score = 0
var player2_score = 0

func _ready():
	# Connect ball signals
	ball.scored_left.connect(_on_player1_scored)
	ball.scored_right.connect(_on_player2_scored)
	
	update_scores()
	create_center_line()

func create_center_line():
	# Create dashed center line
	var screen_height = get_viewport_rect().size.y
	var dash_height = 20
	var gap = 15
	var y_pos = 0
	
	while y_pos < screen_height:
		var line = Line2D.new()
		line.add_point(Vector2(0, y_pos))
		line.add_point(Vector2(0, y_pos + dash_height))
		line.width = 4
		line.default_color = Color(0.5, 0.5, 0.5, 0.5)
		center_line.add_child(line)
		y_pos += dash_height + gap

func _on_player1_scored():
	player1_score += 1
	update_scores()
	check_game_over()

func _on_player2_scored():
	player2_score += 1
	update_scores()
	check_game_over()

func update_scores():
	player1_score_label.text = str(player1_score)
	player2_score_label.text = str(player2_score)

func check_game_over():
	if player1_score >= 10:
		show_winner("Player 1 Wins!")
	elif player2_score >= 10:
		show_winner("Player 2 Wins!")

func show_winner(message):
	var winner_label = $UI/WinnerLabel
	winner_label.text = message
	winner_label.visible = true
	
	# Pause the game
	get_tree().paused = true
	
	# Wait and reset
	await get_tree().create_timer(3.0).timeout
	get_tree().paused = false
	reset_game()

func reset_game():
	player1_score = 0
	player2_score = 0
	update_scores()
	$UI/WinnerLabel.visible = false
	ball.reset_ball()

func _input(event):
	# Press R to reset game
	if event.is_action_pressed("ui_cancel"):
		reset_game()
