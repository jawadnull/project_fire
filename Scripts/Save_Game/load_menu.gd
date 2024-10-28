class_name LoadGame
extends Control

@onready var load_menu: LoadGame = $"."
@onready var player: CharacterBody2D = %Player
@onready var save_menu: SaveGame = $"../SaveMenu"


func load_game():
	
	var saved_game:SavedGame=load("user://savegamedataslot1.tres") as SavedGame
	
	player.global_position=saved_game.player_position
	player.health.set_health(saved_game.player_health)
	
	for weapon_id in player.weapon_manager.weapon_ids.keys():
		if saved_game.weapon_ammo.has(weapon_id):
			var weapon = player.weapon_manager.weapon_ids[weapon_id].instantiate()
			weapon.ammo = saved_game.weapon_ammo[weapon_id] 
	
	
	
	load_menu.visible=false
	save_menu.visible=false
	
