class_name LoadGame
extends Control

@onready var load_menu: LoadGame = $"."
@onready var player: CharacterBody2D = %Player
@onready var save_menu: SaveGame = $"../SaveMenu"


func load_game():
	
	var saved_game:SavedGame=load("user://savegamedataslot1.tres") as SavedGame
	
	player.global_position=saved_game.player_position
	load_menu.visible=false
	save_menu.visible=false
	
