extends CharacterBody2D

@onready var detection: Detection = $Detection  # Reference to the detection node
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D  # Enemy sprite animation
@onready var health: HealthBar = $HealthBar  # Reference to the Health node
@onready var hurtbox: HurtBox = $HurtBox  # Reference to the HurtBox

var knockback_power: int = 200
var speed: int = 100
var dead:bool = false
var knockback = Vector2.ZERO  # Store the knockback vector
var knockback_timer = 0.0  # Timer to track knockback duration

func _ready() -> void:
	dead = false
	health.connect("health_depleted", Callable(self, "_on_enemy_death"))
	hurtbox.connect("received_damage", Callable(self, "_on_received_damage"))
	health.visible=false


func _physics_process(delta: float) -> void:
	
	
	if dead:
		detection.set_deferred("monitoring", false)  # Disables the area from detecting
		return
	
	# Handle knockback
	if knockback_timer > 0:
		knockback_timer -= delta  # Decrease the timer
		velocity = knockback
		knockback = knockback.lerp(Vector2.ZERO, 0.1)  # Decay the knockback
		if knockback.length() < 1:  # Stop applying knockback when it is negligible
			knockback = Vector2.ZERO  # Reset knockback
			knockback_timer = 0.0  # Reset timer
	else:
		if detection.is_player_detected and detection.player != null:
			var player_position = detection.player.position
			var direction = (player_position - position).normalized()
			velocity = direction * speed
			#animated_sprite_2d.play("walk")  # Play walk animation when moving
		else:
			velocity = Vector2.ZERO
			#animated_sprite_2d.play("idle")  # Play idle animation when not moving
	
	# Move the enemy
	move_and_slide()

# Called when damage is received
func _on_received_damage(damage: int,attacker_position: Vector2) -> void:
	health.set_health(health.get_health() - damage)
	print("Health: ", health.get_health())  # Debug 
	health.visible=true
	apply_knockback(attacker_position)


func apply_knockback(attacker_position):
	# Calculate the direction from the attacker to the player
	var knockback_direction = (global_position - attacker_position).normalized()
	knockback = knockback_direction * knockback_power
	knockback_timer = 0.2  # Set duration for knockback effect



func _on_enemy_death() -> void:
	dead = true
	#animated_sprite_2d.play("death")  # Play death animation
	queue_free()  # Remove enemy from the scene
