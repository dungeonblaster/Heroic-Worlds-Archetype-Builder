extends CharacterBody2D

@export var base_speed: float = 420.0
@export var speed_increase: float = 35.0
@export var max_speed: float = 820.0
@export var serve_angle_range: float = 25.0

var _start_position: Vector2
var _rng := RandomNumberGenerator.new()
var _active: bool = false

func _ready() -> void:
	add_to_group("ball")
	_rng.randomize()
	_start_position = global_position
	velocity = Vector2.ZERO

func reset_position() -> void:
	global_position = _start_position
	stop()

func stop() -> void:
	velocity = Vector2.ZERO
	_active = false

func is_active() -> bool:
	return _active

func get_radius() -> float:
	var shape := $CollisionShape2D.shape
	if shape is CircleShape2D:
		return shape.radius
	return 0.0

func serve(direction_sign: int) -> void:
	direction_sign = clamp(direction_sign, -1, 1)
	if direction_sign == 0:
		direction_sign = 1

	var angle := deg_to_rad(_rng.randf_range(-serve_angle_range, serve_angle_range))
	var direction := Vector2(direction_sign, 0.0).rotated(angle).normalized()
	velocity = direction * base_speed
	_active = true

func _physics_process(_delta: float) -> void:
	if not _active:
		return

	var new_velocity := velocity
	move_and_slide()

	var collision_count := get_slide_collision_count()
	for i in range(collision_count):
		var collision := get_slide_collision(i)
		new_velocity = _handle_collision(collision, new_velocity)

	velocity = new_velocity

func _handle_collision(collision: KinematicCollision2D, current_velocity: Vector2) -> Vector2:
	if collision == null:
		return current_velocity

	var normal := collision.get_normal()
	if normal == Vector2.ZERO:
		return current_velocity

	var bounced := current_velocity.bounce(normal)
	var collider := collision.get_collider()

	if collider and collider.is_in_group("paddle") and collider.has_method("modify_ball_velocity"):
		bounced = collider.modify_ball_velocity(global_position, bounced)
		bounced = _increase_speed(bounced)
	else:
		var clamped_speed := clamp(bounced.length(), base_speed, max_speed)
		bounced = bounced.normalized() * clamped_speed

	return bounced

func _increase_speed(incoming_velocity: Vector2) -> Vector2:
	var current_speed := incoming_velocity.length()
	current_speed = clamp(current_speed + speed_increase, base_speed, max_speed)
	return incoming_velocity.normalized() * current_speed
