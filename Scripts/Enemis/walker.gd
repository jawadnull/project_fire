extends CharacterBody2D

@onready var detection: Detection = $Detection  # Reference to the detection node
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D  # Enemy sprite animation
@onready var health: HealthBar = $HealthBar  # Reference to the Health node
@onready var hurtbox: HurtBox = $HurtBox  # Reference to the HurtBox

var speed = 100
var dead = false

func _ready() -> void:
	dead = false
	health.connect("health_depleted", Callable(self, "_on_enemy_death"))
	hurtbox.connect("received_damage", Callable(self, "_on_received_damage"))


func _physics_process(delta: float) -> void:
	if dead:
		detection.set_deferred("monitoring", false)  # Disables the area from detecting
		return

	if detection.is_player_detected and detection.player != null:
		var player_position = detection.player.position
		var direction = (player_position - position).normalized()
		velocity = direction * speed
		position += velocity * delta
		#animated_sprite_2d.play("walk")  # Play walk animation when moving
	else:
		velocity = Vector2.ZERO
		#animated_sprite_2d.play("idle")  # Play idle animation when not moving

# Called when damage is received
func _on_received_damage(damage: int) -> void:
	health.set_health(health.get_health() - damage)

# Called when the enemy's health reaches 0
func _on_enemy_death() -> void:
	dead = true
	#animated_sprite_2d.play("death")  # Play death animation
	queue_free()  # Remove enemy from the scene
