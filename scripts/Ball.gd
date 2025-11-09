extends CharacterBody2D

const INITIAL_SPEED = 300.0
const MAX_SPEED = 600.0
const SPEED_INCREASE = 1.05

var speed = INITIAL_SPEED
var direction = Vector2(1, 0).rotated(randf_range(-PI/4, PI/4))
var screen_width = 1024
var screen_height = 768

signal ball_scored(side)  # "left" or "right"

func _ready():
	reset_ball()

func reset_ball():
	position = Vector2(screen_width / 2, screen_height / 2)
	speed = INITIAL_SPEED
	# Randomize direction, but favor horizontal movement
	var angle = randf_range(-PI/6, PI/6)
	if randf() > 0.5:
		direction = Vector2(1, tan(angle)).normalized()
	else:
		direction = Vector2(-1, tan(angle)).normalized()

func _physics_process(delta):
	velocity = direction * speed
	move_and_slide()
	
	# Check for collisions with walls (top and bottom)
	if position.y <= 10 or position.y >= screen_height - 10:
		direction.y = -direction.y
		# Add slight randomness to prevent boring patterns
		direction.y += randf_range(-0.1, 0.1)
		direction = direction.normalized()
	
	# Check for scoring (ball goes off left or right side)
	if position.x < 0:
		ball_scored.emit("left")
		reset_ball()
	elif position.x > screen_width:
		ball_scored.emit("right")
		reset_ball()
	
	# Check for paddle collisions
	var collision = get_last_slide_collision()
	if collision:
		var collider = collision.get_collider()
		if collider and collider.name == "Paddle":
			# Calculate bounce angle based on where ball hits paddle
			var paddle_pos = collider.position
			var relative_y = (position.y - paddle_pos.y) / 60.0  # Normalize to -1 to 1 (paddle is 120 tall, so half is 60)
			relative_y = clamp(relative_y, -1, 1)
			
			# Reverse x direction and adjust y based on hit position
			direction.x = -direction.x
			direction.y = relative_y * 0.8  # Max angle is about 38 degrees
			direction = direction.normalized()
			
			# Increase speed slightly
			speed = min(speed * SPEED_INCREASE, MAX_SPEED)
			
			# Move ball slightly away from paddle to prevent stuck collisions
			if direction.x > 0:
				position.x = paddle_pos.x + 20
			else:
				position.x = paddle_pos.x - 20