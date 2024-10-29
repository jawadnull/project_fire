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
	
	Global.Inventory.clear()
	Global.Inventory.resize(saved_game.inventory_size)
	for item in saved_game.inventory:
		Global.Inventory.insert(0, item) 
	Global.Inventory_Updated.emit()  
	
	if saved_game.equipped_weapon_id != "":
		player.weapon_manager.switch_weapon_by_id(saved_game.equipped_weapon_id)

	
	load_menu.visible=false
	save_menu.visible=false
	
