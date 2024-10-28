extends Area2D

var Player_In_range=null

@onready var load_menu: LoadGame = $"../Player/LoadMenu"
@onready var save_menu: SaveGame = $"../Player/SaveMenu"



func _process(delta: float) -> void:
	if Player_In_range and Input.is_action_just_pressed("saveMenu"):
		save_menu.visible=!save_menu.visible
	
	
	
	if  Player_In_range and Input.is_action_just_pressed("loadMenu"):
		load_menu.visible=!load_menu.visible
	
	




func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Player_In_range=true
