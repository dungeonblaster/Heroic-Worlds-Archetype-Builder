extends CharacterBody2D

## Ping Pong Ball Controller
## Handles ball physics, bouncing, and scoring

@export var speed: float = 400.0
@export var max_speed: float = 800.0

var screen_size: Vector2
var initial_direction: Vector2

func _ready():
	screen_size = get_viewport_rect().size
	# Random initial direction
	var angle = randf_range(-PI/4, PI/4) + (randi() % 2) * PI
	initial_direction = Vector2(cos(angle), sin(angle))
	velocity = initial_direction * speed

func _physics_process(delta):
	var collision = move_and_slide()
	
	# Bounce off top and bottom walls
	if global_position.y <= 0 or global_position.y >= screen_size.y:
		velocity.y = -velocity.y
		global_position.y = clamp(global_position.y, 0, screen_size.y)
	
	# Check for paddle collisions
	for i in get_slide_collision_count():
		var collision_info = get_slide_collision(i)
		var collider = collision_info.get_collider()
		
		if collider and collider.has_method("is_paddle"):
			# Calculate bounce angle based on where ball hits paddle
			var paddle = collider
			var paddle_height = 120.0  # Match paddle height
			var hit_position = (global_position.y - paddle.global_position.y) / (paddle_height / 2)
			hit_position = clamp(hit_position, -1.0, 1.0)
			
			# Determine which side of the paddle was hit
			var paddle_x = paddle.global_position.x
			if (global_position.x < paddle_x and velocity.x > 0) or (global_position.x > paddle_x and velocity.x < 0):
				# Reverse x direction and adjust y based on hit position
				velocity.x = -velocity.x
				velocity.y = hit_position * speed * 0.8
				
				# Increase speed slightly on each hit
				var current_speed = velocity.length()
				if current_speed < max_speed:
					velocity = velocity.normalized() * min(current_speed * 1.1, max_speed)
			
			break
	
	# Check for scoring (ball goes off left or right side)
	if global_position.x < -50:
		# Right player scores
		var game_manager = get_node_or_null("/root/Main/GameManager")
		if game_manager:
			game_manager.score_point(false)
		reset_ball()
	elif global_position.x > screen_size.x + 50:
		# Left player scores
		var game_manager = get_node_or_null("/root/Main/GameManager")
		if game_manager:
			game_manager.score_point(true)
		reset_ball()

func reset_ball():
	# Reset ball to center
	global_position = screen_size / 2
	
	# Random direction - alternate between left and right
	var angle = randf_range(-PI/4, PI/4)
	if randi() % 2 == 0:
		angle += PI  # Go right
	
	initial_direction = Vector2(cos(angle), sin(angle))
	velocity = initial_direction * speed
