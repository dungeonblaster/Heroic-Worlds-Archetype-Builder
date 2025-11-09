extends Node2D

var left_score = 0
var right_score = 0
var score_to_win = 5

@onready var score_label = $UI/ScoreLabel
@onready var ball = $Ball

func _ready():
	update_score_display()

func _on_ball_scored(side: String):
	if side == "left":
		right_score += 1
	else:
		left_score += 1
	
	update_score_display()
	check_game_over()

func update_score_display():
	score_label.text = str(left_score) + " - " + str(right_score)

func check_game_over():
	if left_score >= score_to_win or right_score >= score_to_win:
		var winner = "Player 1" if left_score >= score_to_win else "Player 2"
		show_game_over(winner)

func show_game_over(winner: String):
	# Pause the game
	get_tree().paused = true
	
	# Create game over UI
	var game_over_label = Label.new()
	game_over_label.text = winner + " Wins!\nPress R to Restart"
	game_over_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	game_over_label.add_theme_font_size_override("font_size", 64)
	game_over_label.position = Vector2(200, 300)
	game_over_label.size = Vector2(624, 200)
	game_over_label.name = "GameOverLabel"
	$UI.add_child(game_over_label)

func _input(event):
	if event.is_action_pressed("ui_accept") or (event is InputEventKey and event.keycode == KEY_R):
		if get_tree().paused:
			# Reset game
			left_score = 0
			right_score = 0
			get_tree().paused = false
			update_score_display()
			ball.reset_ball()
			
			# Remove game over label if it exists
			var game_over = $UI.get_node_or_null("GameOverLabel")
			if game_over:
				game_over.queue_free()