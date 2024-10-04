extends CharacterBody2D

const MOVE_SPEED = 400
const DASH_SPEED = 2000 
const DASH_DURATION = 0.2 
const DASH_COOLDOWN = 0.5  
const ACCELERATION = 1800  
const DECELERATION = 1800  
const SHAKE_INTENSITY = 8  # How intense the shake is
const SHAKE_DURATION = 0.1  # How long the shake lasts

var knockback_power: int = 50
var knockback = Vector2.ZERO  # Store the knockback vector
var knockback_timer = 0.0  # Timer to track knockback duration
var is_walking = false
var last_direction = Vector2.ZERO
var is_dashing = false
var dash_timer = 0.0
var cooldown_timer = 0.0
var current_speed = 0.0  # Player's current movement speed
var shake_timer = 0.0

@onready var weapon_manager = $WeaponManager
@onready var weapon_parent = weapon_manager.get_node("WeaponHolder") 
@onready var camera = $Camera2D  # Reference to the Camera2D node
@onready var sprite = $AnimatedSprite2D
@onready var interactive_ui: CanvasLayer = $InteractiveUI
@onready var inventory_ui: CanvasLayer = $Inventory_UI
@onready var hurtbox: HurtBox = $HurtBox  # Reference to the HurtBox
@onready var health: HealthBar = $Camera2D/HealthBar

#refrence player in global script
func _ready() -> void:
	Global.set_player_refrence(self)
	hurtbox.connect("received_damage", Callable(self, "_on_received_damage"))



func _physics_process(delta):

	# Handle knockback
	if knockback_timer > 0:
		knockback_timer -= delta  # Decrease the timer
		velocity += knockback  # Apply the knockback to the velocity
		knockback = knockback.lerp(Vector2.ZERO, 0.1)  # Decay the knockback over time
		if knockback.length() < 1:  # Stop applying knockback when it is negligible
			knockback = Vector2.ZERO
			knockback_timer = 0.0  # Reset timer
	else:
		# Only move and slide if not knocked back
		handle_input(delta)  # Move the player
	move_and_slide()


	# Update dash timer
	if dash_timer > 0:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false  

	# Update dash cooldown timer
	if cooldown_timer > 0:
		cooldown_timer -= delta

	# Handle camera shake
	if shake_timer > 0:
		shake_timer -= delta
		apply_camera_shake()
	else:
		camera.offset = Vector2.ZERO  # Reset camera offset

	update_sprite_flip()



func handle_input(delta):
	# Handle dash input
	if Input.is_action_just_pressed("dash") and cooldown_timer <= 0:
		start_dash()
	
	if weapon_manager.current_weapon != null:
		if Input.is_action_just_pressed("switch_weapon"):
			weapon_manager.switch_weapon()
	
	if weapon_manager.current_weapon != null:
		if weapon_manager.current_weapon_type == "rifles":
			if Input.is_action_pressed("shoot"):
				weapon_manager.current_weapon.shoot()
			
		else:
			if Input.is_action_just_pressed("shoot"):
				weapon_manager.current_weapon.shoot()
	
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
	
	if Input.is_action_just_pressed("inventory"):
		inventory_ui.visible=!inventory_ui.visible
		get_tree().paused!=get_tree().paused
	
	
	



func add_ammo_to_weapon(ammo_amount,ammo_name):
	if weapon_manager.current_weapon and weapon_manager.current_weapon.has_method("add_ammo"):
		weapon_manager.current_weapon.add_ammo(ammo_amount,ammo_name)
		


func start_dash():
	is_dashing = true
	dash_timer = DASH_DURATION  
	cooldown_timer = DASH_COOLDOWN  
	velocity = last_direction.normalized() * DASH_SPEED  # Dash in the last direction
	
	# Start the camera shake
	shake_timer = SHAKE_DURATION


func apply_camera_shake():
	# Apply a random offset to the camera to create a shake effect
	var shake_offset = Vector2(
		randf_range(-SHAKE_INTENSITY, SHAKE_INTENSITY),
		randf_range(-SHAKE_INTENSITY, SHAKE_INTENSITY)
	)
	camera.offset = shake_offset


func update_sprite_flip():
	var mouse_position = get_global_mouse_position()
	var player_position = global_position

	# Check if the mouse is to the left or right of the player
	if mouse_position.x < player_position.x:
		sprite.flip_h = true  # Flip the sprite to face left
	else:
		sprite.flip_h = false  # Default to facing right




func apply_item_effect(item):
	match item["effect"]:
		"helth+10":
			health.health+=10
		"slot+5":
			Global.Increase_Inventory_Size(5)
		"ammo+10":
			add_ammo_to_weapon(10,"weapon_ammo")
			item["quantity"]-=10
		_:
			print("can't use item here")



func _on_received_damage(damage: int, attacker_position: Vector2) -> void:
	health.set_health(health.get_health() - damage)

	# If player's health reaches 0, trigger death
	if health.get_health() <= 0:
		_on_player_death()
	else:
		# Apply knockback effect
		apply_knockback(attacker_position)


func apply_knockback(attacker_position: Vector2):
	# Calculate the direction from the attacker to the player
	var knockback_direction = (global_position - attacker_position).normalized()
	knockback = knockback_direction * knockback_power
	knockback_timer = 0.2  # Set duration for knockback effect


func _on_player_death():
	# Handle player death (e.g., respawn, game over)
	queue_free()  # You could add respawn or game over logic here
