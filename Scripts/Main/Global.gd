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

	
	


func remove_item(item_type,item_effect):
	for i in range(Inventory.size()):
		if Inventory[i] != null and Inventory[i]["type"]==item_type and Inventory[i]["effect"]==item_effect:
			Inventory[i]["quantity"] -=1
			if Inventory[i]["quantity"] <= 0:
				Inventory[i]=null
			Inventory_Updated.emit()
			return true
	return false

func Increase_Inventory_Size():
	Inventory_Updated.emit()
	

func set_player_refrence(player):
	player_Node=player
	
	

func adjust_drop_position(position):
	var radius=100
	var nearby_items = get_tree().get_nodes_in_group("Items")
	for item in nearby_items:
		if item.global_position.distance_to(position) < radius:
			var random_offset = Vector2(randf_range(-radius,radius),randf_range(-radius,radius))
			position +=random_offset
			break
	return position
	

func drop_item(item_data,drop_position):
	var item_scene= load(item_data["scene_path"])
	var item_instance = item_scene.instantiate()
	item_instance.set_item_data(item_data)
	drop_position= adjust_drop_position(drop_position)
	item_instance.global_position= drop_position
	get_tree().current_scene.add_child(item_instance)
	
	
