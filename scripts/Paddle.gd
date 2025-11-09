extends AnimatableBody2D

@export var move_speed: float = 520.0
@export var up_action: StringName = ""
@export var down_action: StringName = ""
@export var movement_bounds: Vector2 = Vector2(-260.0, 260.0)
@export var use_ai: bool = false
@export var deflection_zone: float = 52.0
@export var smoothing: float = 0.1

var _start_position: Vector2
var _tracked_ball: Node = null
var _target_y: float

func _ready() -> void:
	add_to_group("paddle")
	_start_position = global_position
	_target_y = _start_position.y

func reset_position() -> void:
	global_position = _start_position
	_target_y = global_position.y

func set_bounds(bounds: Vector2) -> void:
	movement_bounds = bounds

func track_ball(ball: Node) -> void:
	_tracked_ball = ball

func _physics_process(delta: float) -> void:
	var direction := 0.0

	if use_ai:
		_update_ai_target()
	else:
		direction = _input_direction()
		_target_y = clamp(global_position.y + direction * move_speed * delta, movement_bounds.x, movement_bounds.y)

	var new_y := lerp(global_position.y, _target_y, clamp(smoothing, 0.0, 1.0))
	global_position.y = clamp(new_y, movement_bounds.x, movement_bounds.y)

func _input_direction() -> float:
	var dir := 0.0
	if up_action != "" and Input.is_action_pressed(up_action):
		dir -= 1.0
	if down_action != "" and Input.is_action_pressed(down_action):
		dir += 1.0
	return dir

func _update_ai_target() -> void:
	if _tracked_ball == null:
		return
	if not _tracked_ball.has_method("is_active") or not _tracked_ball.is_active():
		_target_y = lerp(_target_y, _start_position.y, 0.05)
		return

	var ball_y: float = _tracked_ball.global_position.y
	var clamped_y := clamp(ball_y, movement_bounds.x, movement_bounds.y)
	_target_y = clamped_y

func modify_ball_velocity(ball_position: Vector2, incoming_velocity: Vector2) -> Vector2:
	var horizontal_sign := float(sign(incoming_velocity.x))
	if horizontal_sign == 0.0:
		horizontal_sign = -1.0 if global_position.x > 0.0 else 1.0

	var offset := clamp((ball_position.y - global_position.y) / max(deflection_zone, 1.0), -1.0, 1.0)
	var influence := Vector2(horizontal_sign, offset).normalized()
	var speed := incoming_velocity.length()
	return influence * max(speed, 1.0)
