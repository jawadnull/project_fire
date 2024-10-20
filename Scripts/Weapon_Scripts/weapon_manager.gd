extends Node2D#weapon manager

@export var weapon_inventory = []  # Array of all available weapon scenes (preload or paths to weapons)
var current_weapon_index = 0  # Keeps track of the currently equipped weapon
var current_weapon = null  # Holds a reference to the currently equipped weapon instance
var current_weapon_type = ""  # Stores the type of the currently equipped weapon
var weapon_ids = {}  # Dictionary to store weapon scenes by their ID
@onready var weapon_parent: Node2D = $WeaponHolder  # Reference to the node where the weapon will be added



func _ready():
	if weapon_inventory.size() > 0:
		equip_weapon(0)  # Equip the first weapon by default
		
	print("Weapon inventory contents:")
	for weapon in weapon_inventory:
		print(weapon.resource_path)  # Assuming the weapon is a PackedScene or has a resource path


# Equips a weapon based on the index in the array
func equip_weapon(index):
	if index >= 0 and index < weapon_inventory.size():
		if current_weapon:
			current_weapon.queue_free()  # Remove the current weapon
		current_weapon_index = index
		current_weapon = weapon_inventory[current_weapon_index].instantiate()  # Create the new weapon
		weapon_parent.add_child(current_weapon)  # Add it to the scene under weapon_parent
		current_weapon_type = current_weapon.weapon_type if current_weapon.has_method("weapon_type") else "unknown"  # Save the weapon type
		
		
		
	

# Switches to the next weapon in the list by index
func switch_weapon():
	var next_index = (current_weapon_index + 1) % weapon_inventory.size()
	equip_weapon(next_index)

# Switches to a weapon based on its ID
func switch_weapon_by_id(weapon_id):
	if weapon_ids.has(weapon_id):
		var index = weapon_inventory.find(weapon_ids[weapon_id])
		if index != -1:
			equip_weapon(index)

func add_weapon_by_id(weapon_id, weapon_scene, weapon_texture):
	if not weapon_ids.has(weapon_id):  # Ensure the weapon ID is unique
		if not weapon_inventory.has(weapon_scene):  # Ensure the scene is unique
			weapon_inventory.append(weapon_scene)  # Add the weapon scene
			weapon_ids[weapon_id] = weapon_scene  # Map the weapon ID to the scene
			print("Weapon added:", weapon_id)
		else:
			print("Weapon scene already in inventory:", weapon_id)
	else:
			print("Weapon already in inventory:", weapon_id)





# Function to remove a weapon by index, unequip if it's the current weapon
# Function to remove a weapon by its ID, unequip if it's the current weapon
func remove_weapon_by_id(weapon_id):
	if weapon_ids.has(weapon_id):
		var weapon_scene = weapon_ids[weapon_id]
		var index = weapon_inventory.find(weapon_scene)
		print("Attempting to remove weapon with ID:", weapon_id, "at index:", index)
		print(weapon_inventory)
		
		if index != -1:
			if index == current_weapon_index:  # If the weapon being dropped is the currently equipped one
				current_weapon.queue_free()  # Remove the equipped weapon from the scene
				current_weapon = null  # Clear the reference
				current_weapon_type = ""  # Clear the current weapon type
			
			# Remove the weapon from the inventory
			weapon_inventory.remove_at(index)
			
			# Remove the weapon from the weapon_ids dictionary
			weapon_ids.erase(weapon_id)
			
			# Adjust the current weapon index
			if index <= current_weapon_index:
				current_weapon_index -= 1  # Move index back if necessary
			
			# Ensure the index doesn't go below 0
			if current_weapon_index < 0:
				current_weapon_index = 0
			
			# Equip the next available weapon (if any)
			if weapon_inventory.size() > 0:
				print("Equipping next available weapon.")
				equip_weapon(current_weapon_index)
			else:
				print("No weapons left to equip.")
				current_weapon = null  # No weapon equipped
