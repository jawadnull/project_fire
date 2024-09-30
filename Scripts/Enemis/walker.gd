extends CharacterBody2D

@onready var detection: Detection = $Detection  # Reference to the detection node
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D  # Enemy sprite animation
var speed = 100
var health = 200
var dead = false

func _ready() -> void:
	dead = false

func _physics_process(delta: float) -> void:
	if dead:
		detection.disabled = true
		return
	
	# Check if player is detected by the Detection node
	if detection.is_player_detected:
		var player_position = detection.player.position  # Get player position from detection
		var direction = (player_position - position).normalized()  # Calculate direction towards player
		velocity = direction * speed  # Set velocity towards player
		
		position += velocity * delta  # Move towards player
		#animated_sprite_2d.play("walk")  # Play walk animation
	else:
		velocity = Vector2.ZERO  # Stop moving when player is not detected
		#animated_sprite_2d.play("idle")  # Play idle animation
	if dead:
		detection.disabled=true
