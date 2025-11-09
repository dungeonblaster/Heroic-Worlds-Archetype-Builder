extends CharacterBody2D

const SPEED = 400.0
var is_left_paddle = false

func _ready():
	# Determine if this is the left paddle based on position
	is_left_paddle = position.x < 512

func _physics_process(delta):
	var input_direction = 0.0
	
	if is_left_paddle:
		# Left paddle controls (W/S)
		if Input.is_action_pressed("move_up"):
			input_direction -= 1.0
		if Input.is_action_pressed("move_down"):
			input_direction += 1.0
	else:
		# Right paddle controls (I/K)
		if Input.is_action_pressed("p2_move_up"):
			input_direction -= 1.0
		if Input.is_action_pressed("p2_move_down"):
			input_direction += 1.0
	
	velocity.y = input_direction * SPEED
	
	# Keep paddle within screen bounds
	var screen_height = get_viewport_rect().size.y
	var paddle_height = 60  # Half of visual height (120 total)
	var min_y = paddle_height + 5  # Account for wall
	var max_y = screen_height - paddle_height - 5  # Account for wall
	
	position.y = clamp(position.y, min_y, max_y)
	
	move_and_slide()