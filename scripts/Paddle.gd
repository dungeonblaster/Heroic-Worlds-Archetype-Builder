extends CharacterBody2D

## Ping Pong Paddle Controller
## Handles paddle movement and collision

@export var speed: float = 500.0
@export var is_left_paddle: bool = true

var screen_size: Vector2

func _ready():
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	var input_action_up = ""
	var input_action_down = ""
	
	if is_left_paddle:
		input_action_up = "move_left_paddle_up"
		input_action_down = "move_left_paddle_down"
	else:
		input_action_up = "move_right_paddle_up"
		input_action_down = "move_right_paddle_down"
	
	var direction = 0
	if Input.is_action_pressed(input_action_up):
		direction -= 1
	if Input.is_action_pressed(input_action_down):
		direction += 1
	
	velocity.y = direction * speed
	
	move_and_slide()
	
	# Keep paddle within screen bounds
	global_position.y = clamp(global_position.y, 0, screen_size.y)

func is_paddle() -> bool:
	return true
