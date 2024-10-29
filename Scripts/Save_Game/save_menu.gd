class_name SaveGame
extends Control

@onready var player: CharacterBody2D = %Player



func save_game():
	var saved_game:SavedGame=SavedGame.new()
	
	saved_game.player_position=player.global_position
	saved_game.player_health = player.health.get_health()  
	saved_game.inventory_size = Global.Inventory.size()
	saved_game.equipped_weapon_id = player.weapon_manager.current_weapon_type
	

	for weapon_id in player.weapon_manager.weapon_ids.keys():
		var weapon = player.weapon_manager.weapon_ids[weapon_id].instantiate()
		saved_game.weapon_ammo[weapon_id] = weapon.ammo  
	
	#insert all inventory item into saved_game.inventory
	saved_game.inventory.clear()
	for item in Global.Inventory:
		if item != null:
			saved_game.inventory.append(item)
	
	ResourceSaver.save(saved_game,"user://savegamedataslot1.tres")
