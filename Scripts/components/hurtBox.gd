class_name HurtBox
extends Area2D

signal received_damage(damage: int)  # Signal for when damage is received

@export var health: HealthBar  # Reference to the Health component


func _ready() -> void:
	self.connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(area: Area2D) -> void:
	if area is HitBox:
		var hitbox = area as HitBox
		print("bullet entered")
		health.set_health(health.get_health() - hitbox.damage)
		emit_signal("received_damage", hitbox.damage, global_position)
