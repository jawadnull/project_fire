extends Area2D

@export var weapon_id=0;
@export var weapon_path: PackedScene
@export var weapon_type= "rifle";
@export var weapon_texture:Texture
var player_in_area = false  # Keeps track of whether the player is in the pickup area

# Detect when the player enters the area
func _on_body_entered(body):
	if body.name == "Player":
		player_in_area = true  # Player has entered the area
		print("Player entered the pickup area.")  # Debugging

# Detect when the player exits the area
func _on_body_exited(body):
	if body.name == "Player":
		player_in_area = false  # Player has exited the area
		print("Player exited the pickup area.")  # Debugging

# Handle input to pick up the weapon
func _process(delta):
	var weapon={
		"id":weapon_id,
		"quantity":1,
		"name":"name",
		"scene_path":weapon_path,
		"type":weapon_type,
		"effect":"kill",
		"texture":weapon_texture
	}
	if player_in_area and Input.is_action_just_pressed("pick_up"):  # Wait for "E" key press to pick up
		print("Attempting to pick up weapon...")  # Debugging
		var bodies = get_overlapping_bodies()
		var player = null
		if Global.player_Node:
			Global.Add_Item(weapon)
		# Find the player in the overlapping bodies
		for body in bodies:
			if body.name == "Player":
				player = body
				print("Player found!")  # Debugging
				break

		if player:
			var weapon_manager = player.weapon_manager
			if weapon_manager:
				print("Weapon manager found, adding weapon to player.")  # Debugging
				weapon_manager.weapon_scenes.append(weapon_path)  # Add the new weapon to the player's weapon manager
				weapon_manager.equip_weapon(weapon_manager.weapon_scenes.size() - 1)  # Equip the picked-up weapon
				
				queue_free()  # Remove the weapon from the scene after pickup
			else:
				print("Weapon manager not found on player.")
		else:
			print("Player not found in the area.")
