extends CharacterBody2D

var speed = 500.0
var direction = Vector2.ZERO

signal scored_left
signal scored_right

func _ready():
	reset_ball()

func reset_ball():
	position = get_viewport_rect().size / 2
	# Random initial direction
	var angle = randf_range(-PI/4, PI/4)
	if randf() > 0.5:
		angle += PI
	direction = Vector2(cos(angle), sin(angle)).normalized()
	speed = 500.0

func _physics_process(delta):
	velocity = direction * speed
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		var collider = collision.get_collider()
		
		# Bounce off paddles with angle variation
		if collider.is_in_group("paddle"):
			var paddle_height = collider.get_node("CollisionShape2D").shape.size.y
			var paddle_center = collider.position.y
			var hit_position = (position.y - paddle_center) / (paddle_height / 2)
			hit_position = clamp(hit_position, -0.8, 0.8)
			
			var angle = hit_position * PI / 3
			direction.x = -direction.x
			direction.y = sin(angle)
			direction = direction.normalized()
			
			# Increase speed slightly on paddle hit
			speed = min(speed * 1.05, 800.0)
			
			# Play sound effect (visual/audio feedback)
			var tween = create_tween()
			tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.1)
			tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
		else:
			# Bounce off top and bottom walls
			direction.y = -direction.y
	
	# Check if ball went out of bounds
	var screen_size = get_viewport_rect().size
	if position.x < 0:
		scored_right.emit()
		reset_ball()
	elif position.x > screen_size.x:
		scored_left.emit()
		reset_ball()
