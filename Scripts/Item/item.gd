@tool
extends Node2D

@export var Item_Name=""
@export var Item_Type=""
@export var Item_Effect=""
@export var Item_Texture:Texture
var Scene_Path="res://Scenes/Item/item.tscn"

@onready var Icone_Sprite: Sprite2D = $Sprite2D

var Player_In_range=null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		Icone_Sprite.texture=Item_Texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if  Engine.is_editor_hint():
		Icone_Sprite.texture=Item_Texture
	if Player_In_range and Input.is_action_just_pressed("pick_up"):
		pickup_item()


func pickup_item():
	var Item={
		"quantity":1,
		"name":Item_Name,
		"type":Item_Type,
		"texture":Item_Texture,
		"effect":Item_Effect,
		"scene_path":Scene_Path
	}
	
	if Global.player_Node:
		Global.Add_Item(Item)
		self.queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Player_In_range=true
		body.interactive_ui.visible=true
		

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Player_In_range=false 
		body.interactive_ui.visible=false
