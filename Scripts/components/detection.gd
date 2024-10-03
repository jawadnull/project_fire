class_name Detection
extends Area2D

@export var detection_radius = 200.0  # Detection radius
@export var cone_angle_degrees = 90.0  # Angle for the detection cone
@export var requires_line_of_sight = true  # If true, requires clear visibility to detect
@export var alert_duration = 2.0  # Duration of alert when player is detected
@export var line_of_sight_check_interval = 0.1  # Interval for line of sight checks
@export var alert_stop_time = 5.0  # Time in seconds for the alert to stop after player is lost
var is_player_detected = false
var player
var alert_timer: Timer
var los_timer: Timer  # Timer for line of sight checks
var countdown_timer: Timer  # Timer for alert stop countdown

func _ready():
	# Initialize alert timer
	alert_timer = Timer.new()
	alert_timer.wait_time = alert_duration
	alert_timer.one_shot = true
	add_child(alert_timer)
	alert_timer.timeout.connect(_on_alert_timeout)

	# Initialize line of sight timer
	los_timer = Timer.new()
	los_timer.wait_time = line_of_sight_check_interval
	los_timer.one_shot = false  # Repeat the timer
	add_child(los_timer)
	los_timer.timeout.connect(check_line_of_sight)

	# Initialize countdown timer for alert stop
	countdown_timer = Timer.new()
	countdown_timer.wait_time = alert_stop_time  # Duration for alert stop countdown
	countdown_timer.one_shot = true  # Only run once
	add_child(countdown_timer)
	countdown_timer.timeout.connect(stop_alert_final)

# Called when a body enters the detection area
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		#print("Player detected!")
		player=body
		start_alert()

# Called when a body exits the detection area
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		#print("Player lost!")
		stop_alert()  # Start the alert stop countdown

# Start alert and start checking line of sight
func start_alert() -> void:
	if not is_player_detected:  # Only start alert if not already in alert state
		#print("Alert started!")
		is_player_detected = true
		alert_timer.start()
		if requires_line_of_sight:
			los_timer.start()  # Start the line of sight checks

# Stop alert and start countdown for stopping the alert
func stop_alert() -> void:
	if is_player_detected:
		#print("Stopping alert countdown...")
		countdown_timer.start()  # Start the countdown timer

# Final stop alert function after countdown
func stop_alert_final() -> void:
	if is_player_detected:
		#print("Alert stopped!")  # Debug statement
		is_player_detected = false
		alert_timer.stop()  # Stop alert timer
		los_timer.stop()  # Stop line of sight checks

# Called when the alert timer ends
func _on_alert_timeout() -> void:
	print("Alert ended!")

# Check if there's a clear line of sight to the player
func check_line_of_sight() -> void:
	if Global.player_Node and is_instance_valid(Global.player_Node):
		if not has_line_of_sight():
			#print("Line of sight lost!")
			stop_alert()  # Stop alert if line of sight is lost

# Check for line of sight
func has_line_of_sight() -> bool:
	if Global.player_Node:
		var space_state = get_world_2d().direct_space_state
		var ray_query = PhysicsRayQueryParameters2D.create(global_position, Global.player_Node.global_position)
		ray_query.exclude = [self, Global.player_Node]  # Exclude the enemy itself and the player from the raycast
		
		#print("Raycasting from:", global_position, "to:", Global.player_Node.global_position)  # Debug output

		var result = space_state.intersect_ray(ray_query)
		if result.is_empty():
			print("No obstacle in sight!")  # Debug statement for line of sight
			return true  # True if there's no obstacle blocking the view
		else:
			print("Obstacle detected:", result.collider.name)  # Which object is blocking the ray
	return false
