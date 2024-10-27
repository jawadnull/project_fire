class_name SaveGame
extends Control

@onready var player: CharacterBody2D = %Player



func save_game():
	var saved_game:SavedGame=SavedGame.new()
	
	saved_game.player_position=player.global_position
	
	ResourceSaver.save(saved_game,"user://savegamedataslot1.tres")
