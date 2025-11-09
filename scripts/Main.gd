extends Node2D

@export var table_half_extents: Vector2 = Vector2(560.0, 320.0)
@export var score_to_win: int = 11
@export var win_by_two: bool = true
@export var serve_prompt: String = "Press Space to Serve"
@export var restart_prompt: String = "Press R to Restart"
@export var victory_template: String = "%s player wins!"
@export var vertical_margin: float = 68.0

@onready var ball: CharacterBody2D = $Ball
@onready var left_paddle: Node = $LeftPaddle
@onready var right_paddle: Node = $RightPaddle
@onready var score_left_label: Label = $HUD/ScoreLeft
@onready var score_right_label: Label = $HUD/ScoreRight
@onready var message_label: Label = $HUD/Message

var _scores := [0, 0]
var _round_active := false
var _game_over := false
var _serve_direction := 1
var _left_start: Vector2
var _right_start: Vector2

func _ready() -> void:
	randomize()
	add_to_group("game")
	_left_start = left_paddle.global_position
	_right_start = right_paddle.global_position
	_serve_direction = 1 if randi() % 2 == 0 else -1
	_configure_paddles()
	_reset_round_state()
	_update_score_labels()

func _process(_delta: float) -> void:
	if _game_over:
		if Input.is_action_just_pressed("restart_game"):
			_reset_match()
		return

	if not _round_active and Input.is_action_just_pressed("serve_ball"):
		_begin_round()

func _physics_process(_delta: float) -> void:
	if not _round_active or _game_over:
		return

	var horizontal_limit := table_half_extents.x + ball.get_radius()
	if ball.global_position.x < -horizontal_limit:
		_award_point(1)
	elif ball.global_position.x > horizontal_limit:
		_award_point(0)

func _configure_paddles() -> void:
	var min_y := -table_half_extents.y + vertical_margin
	var max_y := table_half_extents.y - vertical_margin
	var bounds := Vector2(min_y, max_y)

	if left_paddle.has_method("set_bounds"):
		left_paddle.set_bounds(bounds)
	if left_paddle.has_method("track_ball"):
		left_paddle.track_ball(ball)

	if right_paddle.has_method("set_bounds"):
		right_paddle.set_bounds(bounds)
	if right_paddle.has_method("track_ball"):
		right_paddle.track_ball(ball)

func _reset_round_state() -> void:
	_round_active = false
	_game_over = false if (_scores[0] == 0 and _scores[1] == 0) else _game_over
	ball.reset_position()
	if left_paddle.has_method("reset_position"):
		left_paddle.reset_position()
	else:
		left_paddle.global_position = _left_start
	if right_paddle.has_method("reset_position"):
		right_paddle.reset_position()
	else:
		right_paddle.global_position = _right_start

	message_label.text = serve_prompt
	message_label.visible = true

func _begin_round() -> void:
	if _round_active or _game_over:
		return

	_round_active = true
	message_label.visible = false
	ball.serve(_serve_direction)

func _award_point(player_index: int) -> void:
	_round_active = false
	if player_index == 0:
		_scores[0] += 1
		_serve_direction = 1
	else:
		_scores[1] += 1
		_serve_direction = -1

	_update_score_labels()

	if _check_for_victory(player_index):
		return

	_reset_round_state()

func _check_for_victory(player_index: int) -> bool:
	var left := _scores[0]
	var right := _scores[1]
	var leader_score := max(left, right)
	var lead := abs(left - right)

	var victory := false
	if win_by_two:
		victory = leader_score >= score_to_win and lead >= 2
	else:
		victory = leader_score >= score_to_win

	if victory:
		_finish_match(player_index)
		return true

	return false

func _finish_match(winner_index: int) -> void:
	_game_over = true
	_round_active = false
	ball.reset_position()
	if left_paddle.has_method("reset_position"):
		left_paddle.reset_position()
	if right_paddle.has_method("reset_position"):
		right_paddle.reset_position()
	var winner_name := "Left" if winner_index == 0 else "Right"
	message_label.text = victory_template % winner_name + "\n" + restart_prompt
	message_label.visible = true

func _reset_match() -> void:
	_scores = [0, 0]
	_update_score_labels()
	_game_over = false
	_serve_direction = 1 if randi() % 2 == 0 else -1
	_reset_round_state()

func _update_score_labels() -> void:
	score_left_label.text = str(_scores[0])
	score_right_label.text = str(_scores[1])
