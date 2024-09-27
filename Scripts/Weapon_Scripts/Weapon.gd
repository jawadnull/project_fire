extends Node2D  # Gun

var shoot_speed = 3.0  
var recoil_strength = 5.0  
var recoil_speed = 10.0  
var max_recoil_distance = 10.0  
var shoot_timer = 0.1
const weapon_type = "rifles"
var ammo_name="weapon_ammo"

@onready var marker_2d = $Marker2D  
@onready var camera = get_node("/root/Main/Player/Camera2D")  # Reference to your Camera2D node

const BULLET = preload("res://Scenes/Bullets/rifle_bullet.tscn")

# Gun properties
var max_ammo = 3  # Maximum bullets in a magazine
var ammo = max_ammo  # Current bullets in magazine
var reserve_ammo = 3  # Total reserve bullets
var reload_time = 1.5  # Time to reload in seconds

var can_shoot = true
var is_reloading = false
var bulletDirection = Vector2(1, 0)  
var facing_right = true  
var recoil_offset = Vector2.ZERO  

# Camera shake properties
var shake_duration = 0.1  
var shake_intensity = 1.0  
var shake_timer = 0.0  
var is_shaking = false  

func _ready():
	shoot_timer = 0.0  

# Function to handle shooting
func shoot():
	if can_shoot and ammo > 0 and not is_reloading:
		can_shoot = false
		shoot_timer = 0.0  

		# Spawn bullet
		var bulletNode = BULLET.instantiate()
		bulletNode.set_direction(bulletDirection)
		get_tree().root.add_child(bulletNode)
		bulletNode.global_position = marker_2d.global_position

		# Decrease ammo count
		ammo -= 1
		
		# Apply recoil
		apply_recoil()

		# Start camera shake effect
		start_camera_shake()
	elif ammo == 0 and not is_reloading:
		start_reload()  # Trigger reload when ammo is empty


# Adds ammo to the current weapon
func add_ammo(amount, ammo_name):
	if ammo_name == self.ammo_name:
		var ammo_needed = max_ammo - ammo
		var ammo_to_add = min(amount, ammo_needed)
		ammo += ammo_to_add  # Add ammo to current magazine
		reserve_ammo += (amount - ammo_to_add)  # Add any excess to the reserve



# Function to apply recoil
func apply_recoil():
	var recoil_vector = -bulletDirection * recoil_strength
	recoil_offset += recoil_vector

	if recoil_offset.length() > max_recoil_distance:
		recoil_offset = recoil_offset.normalized() * max_recoil_distance

# Function to start reload process
func start_reload():
	if not is_reloading and ammo < max_ammo and reserve_ammo > 0:
		is_reloading = true
		await get_tree().create_timer(reload_time).timeout  # Await the reload time
		perform_reload()

# Function to reload the gun
func perform_reload():
	var bullets_to_reload = min(max_ammo - ammo, reserve_ammo)
	ammo += bullets_to_reload
	reserve_ammo -= bullets_to_reload
	is_reloading = false

# Input event handling
func _input(event):
	if event.is_action_pressed("reload") and not is_reloading:
		start_reload()

func setup_direction(delta):
	var current_global_position = global_position
	var mouse_position = get_global_mouse_position()

	# Calculate bullet direction
	bulletDirection = (mouse_position - current_global_position).normalized()
	var angle_to_mouse = current_global_position.angle_to_point(mouse_position)
	
	if mouse_position.x > current_global_position.x:
		if not facing_right:
			scale.x = 1  # Flip to face right
			facing_right = true
		rotation = lerp_angle(rotation, angle_to_mouse, 5 * delta)
	else:
		if facing_right:
			scale.x = -1  # Flip to face left
			facing_right = false
		rotation = lerp_angle(rotation, angle_to_mouse + PI, 5 * delta)

# Recoil handling
func update_recoil(delta):
	recoil_offset = recoil_offset.lerp(Vector2.ZERO, recoil_speed * delta)

func _physics_process(delta):
	setup_direction(delta)

	# Recoil update
	if recoil_offset != Vector2.ZERO:
		position = recoil_offset

	update_recoil(delta)

	# Fire rate control
	if not can_shoot:
		shoot_timer += delta
		if shoot_timer >= 1.0 / shoot_speed:
			can_shoot = true

	# Camera shake update
	if is_shaking:
		update_camera_shake(delta)

# Camera shake logic
func start_camera_shake():
	shake_timer = shake_duration  # Reset the shake timer
	is_shaking = true  # Activate the shake

func update_camera_shake(delta):
	if shake_timer > 0.0:
		var random_offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * shake_intensity
		camera.offset = random_offset  # Apply random shake offset to the camera
		shake_timer -= delta  # Reduce shake timer
	else:
		camera.offset = Vector2.ZERO  # Reset camera position
		is_shaking = false
