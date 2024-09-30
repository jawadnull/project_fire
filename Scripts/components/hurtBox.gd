class_name HurtBox
extends Area2D

signal recived_damage(damage:int)

var health: Health 

func _ready() -> void:
	connect("area_enterd",_on_area_entered)

func _on_area_entered(hitbox:HitBox)->void:
	if hitbox != null:
		health.health-=hitbox.damage 
		recived_damage.emit(hitbox.damage)
