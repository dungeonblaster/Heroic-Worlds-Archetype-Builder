extends StaticBody2D

@export var speed = 400.0
@export var player_number = 1

var input_up = ""
var input_down = ""

func _ready():
	add_to_group("paddle")
	
	if player_number == 1:
		input_up = "player1_up"
		input_down = "player1_down"
	else:
		input_up = "player2_up"
		input_down = "player2_down"

func _physics_process(delta):
	var direction = 0.0
	
	if Input.is_action_pressed(input_up):
		direction -= 1.0
	if Input.is_action_pressed(input_down):
		direction += 1.0
	
	# Move the paddle
	position.y += direction * speed * delta
	
	# Keep paddle within screen bounds
	var screen_height = get_viewport_rect().size.y
	var paddle_height = $CollisionShape2D.shape.size.y
	position.y = clamp(position.y, paddle_height / 2, screen_height - paddle_height / 2)
