extends Area2D  # Bullet

@export var speed = 2000  # Bullet speed (adjust as needed)
@export var damage = 100  # Damage the bullet deals

var direction = Vector2.ZERO  # Bullet movement direction

# Set the bullet's direction from the gun
func set_direction(bulletDirection: Vector2):
	direction = bulletDirection.normalized()  # Normalize the direction for proper speed
	rotation_degrees = direction.angle() * 180 / PI  # Rotate the bullet to face its direction

func _ready():
	# Destroy the bullet after 3 seconds to avoid memory issues
	await get_tree().create_timer(3).timeout
	queue_free()

func _physics_process(delta):
	# Move the bullet in the set direction with constant speed
	global_position += direction * speed * delta

# Handle collisions with enemies or other objects
func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.take_damage(damage)  # Apply damage to the enemy
		queue_free()  # Destroy the bullet after impact
