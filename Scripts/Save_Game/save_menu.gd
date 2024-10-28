class_name SaveGame
extends Control

@onready var player: CharacterBody2D = %Player



func save_game():
	var saved_game:SavedGame=SavedGame.new()
	
	saved_game.player_position=player.global_position
	saved_game.player_health = player.health.get_health()  
	
	for weapon_id in player.weapon_manager.weapon_ids.keys():
		var weapon = player.weapon_manager.weapon_ids[weapon_id].instantiate()
		saved_game.weapon_ammo[weapon_id] = weapon.ammo  
	
	
	ResourceSaver.save(saved_game,"user://savegamedataslot1.tres")
