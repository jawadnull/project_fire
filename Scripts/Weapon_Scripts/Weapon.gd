extends Node2D  # gun

var shoot_speed = 10.0  
var recoil_strength = 5.0  
var recoil_speed = 10.0  
var max_recoil_distance = 10.0  
var shoot_timer = 0.1
@export var weapon_type="rifles";
@onready var marker_2d = $Marker2D  

const BULLET = preload("res://Scenes/Bullets/Bullet.tscn")
@onready var camera =get_node("/root/Game/Player/Camera2D")  # Add a reference to your Camera2D node

var can_shoot = true
var bulletDirection = Vector2(1, 0)  
var facing_right = true  
var recoil_offset = Vector2.ZERO  

var shake_duration = 0.1  # Duration of the camera shake effect
var shake_intensity = 1.0  # Intensity of the camera shake
var shake_timer = 0.0  # Timer for tracking shake duration
var is_shaking = false  # To track if the shake is active

func _ready():
	shoot_timer = 0.0  

func apply_recoil():
	var recoil_vector = -bulletDirection * recoil_strength
	recoil_offset += recoil_vector

	if recoil_offset.length() > max_recoil_distance:
		recoil_offset = recoil_offset.normalized() * max_recoil_distance

func shoot():
	if can_shoot:
		can_shoot = false
		shoot_timer = 0.0  

		var bulletNode = BULLET.instantiate()

		# Set the bullet's direction
		bulletNode.set_direction(bulletDirection)
		
		# Add the bullet to the scene tree
		get_tree().root.add_child(bulletNode)
		
		# Set the bullet's initial position relative to the gun's marker
		bulletNode.global_position = marker_2d.global_position
		
		# Apply recoil to the gun
		apply_recoil()

		# Start camera shake effect
		start_camera_shake()

func setup_direction(delta):
	var current_global_position = global_position
	var mouse_position = get_global_mouse_position()

	# Calculate bullet direction independently of player movement
	bulletDirection = (mouse_position - current_global_position).normalized()
	var angle_to_mouse = current_global_position.angle_to_point(mouse_position)
	
	if mouse_position.x > current_global_position.x:
		if not facing_right:
			scale.x = 1  # Flip to face the right direction
			facing_right = true
		rotation = lerp_angle(rotation, angle_to_mouse, 5 * delta)
	else:
		if facing_right:
			scale.x = -1  # Flip to face the left direction
			facing_right = false
		rotation = lerp_angle(rotation, angle_to_mouse + PI, 5 * delta)

func update_recoil(delta):
	recoil_offset = recoil_offset.lerp(Vector2.ZERO, recoil_speed * delta)

func _physics_process(delta):
	setup_direction(delta)
	
	if recoil_offset != Vector2.ZERO:
		position = recoil_offset

	update_recoil(delta)

	# Update camera shake if it's active
	if is_shaking:
		update_camera_shake(delta)

	if not can_shoot:
		shoot_timer += delta
		if shoot_timer >= 1.0 / shoot_speed:
			can_shoot = true

# Camera shake logic
func start_camera_shake():
	shake_timer = shake_duration  # Reset the shake timer
	is_shaking = true  # Activate the shake

func update_camera_shake(delta):
	if shake_timer > 0.0:
		# Generate random offsets for the shake effect
		var random_offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * shake_intensity
		camera.offset = random_offset  # Apply the random shake offset to the camera
		shake_timer -= delta  # Decrease the shake timer
	else:
		# Once the shake is over, reset the camera position and stop the shake
		camera.offset = Vector2.ZERO
		is_shaking = false
