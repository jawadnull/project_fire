extends CharacterBody2D

const MOVE_SPEED = 400
const DASH_SPEED = 800  
const DASH_DURATION = 0.2  
const DASH_COOLDOWN = 0.5  
const ACCELERATION = 1800  
const DECELERATION = 1400  

@export var playerHelth = 100

var is_walking = false
var last_direction = Vector2.ZERO
var is_dashing = false
var dash_timer = 0.0
var cooldown_timer = 0.0
var current_speed = 0.0  # Player's current movement speed

func _physics_process(delta):
	handle_input(delta)

	# Move the character using the built-in velocity property
	move_and_slide()

	# Update dash timer
	if dash_timer > 0:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false  

	# Update dash cooldown timer
	if cooldown_timer > 0:
		cooldown_timer -= delta


func _ready():
	add_to_group("kill")


func handle_input(delta):
	# Handle dash input
	if Input.is_action_just_pressed("dash") and cooldown_timer <= 0:
		start_dash()

	# Get movement input
	var direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

	is_walking = direction.length() > 0  # Check if walking

	if is_dashing:
		# Set velocity for dashing
		velocity = last_direction.normalized() * DASH_SPEED
	elif is_walking:
		# Accelerate when walking
		current_speed = min(current_speed + ACCELERATION * delta, MOVE_SPEED)
		velocity = direction.normalized() * current_speed
		last_direction = direction  # Update last direction if walking
	else:
		# Decelerate when not walking
		current_speed = max(current_speed - DECELERATION * delta, 0)
		velocity = last_direction.normalized() * current_speed


func start_dash():
	is_dashing = true
	dash_timer = DASH_DURATION  
	cooldown_timer = DASH_COOLDOWN  
	velocity = last_direction.normalized() * DASH_SPEED  # Dash in the last direction
