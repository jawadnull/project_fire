extends Area2D# pick up ammo


@export var ammo_amount = 10  # How much ammo this pickup provides

# Signal to notify when ammo is picked up
signal ammo_picked_up(ammo_amount)


# Detect collision with player
func _on_body_entered(body):
	if body.has_method("add_ammo_to_weapon"):
		# Call the player's method to add ammo to the current weapon
		body.add_ammo_to_weapon(ammo_amount)
		emit_signal("ammo_picked_up", ammo_amount)  # Emit signal if needed for feedback
		queue_free()  # Remove the ammo pickup after it's collected
