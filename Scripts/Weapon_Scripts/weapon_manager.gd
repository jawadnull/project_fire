extends Node2D

@export var weapon_scenes = []  # Array of all available weapon scenes (preload or paths to weapons)
var current_weapon_index = 0  # Keeps track of the currently equipped weapon
var current_weapon = null  # Holds a reference to the currently equipped weapon instance
var current_weapon_type = ""  # Stores the type of the currently equipped weapon
var weapon_ids = {}  # Dictionary to store weapon scenes by their ID

@onready var weapon_parent = $WeaponHolder  # Reference to the node where the weapon will be added

func _ready():
	if weapon_scenes.size() > 0:
		equip_weapon(0)  # Equip the first weapon by default

# Equips a weapon based on the index in the array
func equip_weapon(index):
	if index >= 0 and index < weapon_scenes.size():
		if current_weapon:
			current_weapon.queue_free()  # Remove the current weapon
		current_weapon_index = index
		current_weapon = weapon_scenes[current_weapon_index].instantiate()  # Create the new weapon
		weapon_parent.add_child(current_weapon)  # Add it to the scene under weapon_parent
		current_weapon_type = current_weapon.weapon_type if current_weapon.has_method("weapon_type") else "unknown"  # Save the weapon type

# Switches to the next weapon in the list by index
func switch_weapon():
	var next_index = (current_weapon_index + 1) % weapon_scenes.size()
	equip_weapon(next_index)

# Switches to a weapon based on its ID
func switch_weapon_by_id(weapon_id):
	if weapon_ids.has(weapon_id):
		var index = weapon_scenes.find(weapon_ids[weapon_id])
		if index != -1:
			equip_weapon(index)

# Adds a weapon to the weapon manager by ID
func add_weapon_by_id(weapon_id, weapon_scene):
	weapon_scenes.append(weapon_scene)  # Add the weapon scene
	weapon_ids[weapon_id] = weapon_scene  # Map the weapon ID to the scene
