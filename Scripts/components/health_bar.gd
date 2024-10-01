class_name HealthBar
extends TextureProgressBar

signal max_health_changed(diff: int)
signal health_changed(diff: int)
signal health_depleted

@export var max_health: int = 100 : set=set_max_health, get=get_max_health
@export var immortality: bool = false : set=set_immortality, get=get_immortality
var immortality_timer = null
@onready var health: int = max_health : set=set_health, get=get_health

# Set the max health and update the TextureProgressBar
func set_max_health(value: int):
	var clamped_value = max(1, value)  # Ensures health is always at least 1
	if clamped_value != max_health:
		var difference = clamped_value - max_health
		max_health = clamped_value
		emit_signal("max_health_changed", difference)
		
		# Update the progress bar range
		max_value = max_health
		if health > max_health:
			health = max_health
			value = health

func get_max_health() -> int:
	return max_health

# Set health and update the TextureProgressBar's value to reflect health change
func set_health(value: int):
	if value < health and immortality:
		return

	var clamped_value = clamp(value, 0, max_health)
	if clamped_value != health:
		var difference = clamped_value - health
		health = clamped_value
		
		# Update the TextureProgressBar value to reflect the health
		self.value = health  # This adjusts the visual part of the bar
		
		emit_signal("health_changed", difference)
		if health == 0:
			emit_signal("health_depleted")

func get_health() -> int:
	return health

func set_immortality(value: bool):
	immortality = value

func get_immortality() -> bool:
	return immortality

# Temporarily enable immortality for a set time
func set_temporary_immortality(time: float):
	if immortality_timer == null:
		immortality_timer = Timer.new()
		immortality_timer.one_shot = true
		add_child(immortality_timer)
	
	if immortality_timer.timeout.is_connected(set_immortality):
		immortality_timer.timeout.disconnect(set_immortality)
	
	immortality_timer.set_wait_time(time)
	immortality_timer.timeout.connect(set_immortality.bind(false))
	immortality = true
	immortality_timer.start()
