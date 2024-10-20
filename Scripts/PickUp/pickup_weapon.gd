extends Area2D#pick up weapon

@export var weapon_id:int=0;
@export var weapon_path: PackedScene
@export var weapon_name:String=""
@export var weapon_type:String= "rifle";
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
		"name":weapon_name,
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
				if not weapon_manager.weapon_ids.has(weapon_id):  # Check by weapon ID first
					print("Weapon not in inventory, adding weapon.")
					weapon_manager.add_weapon_by_id(weapon_id, weapon_path, weapon_texture)
					weapon_manager.equip_weapon(weapon_manager.weapon_inventory.size() - 1)  # Equip the picked-up weapon
				else:
					print("Weapon already in inventory:", weapon_id)
				
				queue_free()  # Remove the weapon from the scene after pickup
			else:
				print("Weapon manager not found on player.")
		else:
			print("Player not found in the area.")

func set_weapon_data(data):
	weapon_id = data.get("id", 0)
	weapon_name = data.get("name", "")
	weapon_type = data.get("type", "")
	weapon_texture = data.get("texture", null)
	weapon_path = data.get("scene_path", null)
