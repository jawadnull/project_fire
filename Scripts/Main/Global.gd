extends Node #Global


var Inventory=[]

signal Inventory_Updated

var player_Node: Node=null
@onready var Inventory_slot_scene= preload("res://Scenes/Inventory/inventory_slot.tscn")


func _ready() -> void:
	Inventory.resize(10)
	

func Add_Item(Item):
	for i in range(Inventory.size()):
		if Inventory[i] != null and Inventory[i]["type"]==Item["type"] and Inventory[i]["effect"]==Item["effect"]:
			Inventory[i]["quantity"] += Item["quantity"]
			Inventory_Updated.emit()
			return true
		elif Inventory[i] == null:
			Inventory[i]=Item
			Inventory_Updated.emit()
			return true
	return false

	
	


func Remove_Item(item_type,item_effect):
	Inventory_Updated.emit()


func Increase_Inventory_Size():
	Inventory_Updated.emit()
	

func set_player_refrence(player):
	player_Node=player
