@tool
extends Node2D

@export var Item_Name=""
@export var Item_Type=""
@export var Item_Effect=""
@export var Item_Texture:Texture
var Scene_Path="res://Scenes/Item/item.tscn"

@onready var Icone_Sprite: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint():
		Icone_Sprite.texture=Item_Texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if  Engine.is_editor_hint():
		Icone_Sprite.texture=Item_Texture


func pickup_item():
	var Item={
		"quantity":1,
		"item_name":Item_Name,
		"item_type":Item_Type,
		"item_texture":Item_Texture,
		"item_effect":Item_Effect,
		"scene_path":Scene_Path
	}
	
	if Global.player_Node:
		Global.Add_Item(Item)
		self.queue_free()
