extends Control

@onready var item_icon: Sprite2D = $background/ItemIcon
@onready var item_quantity: Label = $background/ItemQuantity
@onready var details_panel: ColorRect = $DetailsPanel
@onready var item_name: Label = $DetailsPanel/ItemName
@onready var item_type: Label = $DetailsPanel/ItemType
@onready var item_effect: Label = $DetailsPanel/ItemEffect
@onready var usage_panel: ColorRect = $UsagePanel
@onready var details_icon: Sprite2D = $DetailsPanel/detailsIcon


#slot Item
var item=null


func _on_item_button_pressed() -> void:
	if item != null:
		usage_panel.visible=true

func _on_item_button_mouse_entered() -> void:
	if item != null:
		usage_panel.visible=false
		details_panel.visible=true

func _on_item_button_mouse_exited() -> void:
	details_panel.visible=false



func set_empty():
	item_icon.texture=null
	item_quantity.text=""
	
	

func set_item(new_item):
	item=new_item
	item_icon.texture=new_item["texture"]
	details_icon.texture=new_item["texture"]
	item_quantity.text=str(item["quantity"])
	item_name.text=str(item["name"])
	item_type.text=str(item["type"])
	
	if item["effect"] !="":
		item_effect.text=str("+ ",item["effect"])
	else:
		item_effect.text=""
	
	


func _on_drop_button_pressed() -> void:
	if item != null:
		var drop_position= Global.player_Node.global_position
		var drop_offset= Vector2(0,50)
		drop_offset=drop_offset.rotated(Global.player_Node.rotation)
		Global.drop_item(item, drop_position)
		Global.remove_item(item["type"],item["effect"])
		usage_panel.visible=false
		


func _on_use_button_pressed() -> void:
	usage_panel.visible=false
	if item != null and item["effect"]!="":
		if Global.player_Node:
			Global.player_Node.apply_item_effect(item)
			Global.remove_item(item["type"],item["effect"])
		else :
			print("player not found")
