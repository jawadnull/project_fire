extends Node #Global


var Inventory=[]

signal Inventory_Update

var player_Node: Node=null

func _ready() -> void:
	Inventory.resize(10)
	


func Add_Item(Item):
	Inventory_Update.emit()


func Remove_Item(Item):
	Inventory_Update.emit()


func Increase_Inventory_Size():
	Inventory_Update.emit()
	

func set_player_refrence(player):
	player_Node=player
