extends Control # inventory  slot

@onready var item_icon: Sprite2D = $background/ItemIcon
@onready var item_quantity: Label = $background/ItemQuantity
@onready var usage_panel: ColorRect = $UsagePanel

signal mouse_entered_item(new_item)

#slot Item
var item=null


func _on_item_button_pressed() -> void:
	if item != null:
		usage_panel.visible=!usage_panel.visible
		

func _on_item_button_mouse_entered() -> void:
	if item != null:
		emit_signal("mouse_entered_item", item)



func set_empty():
	item_icon.texture=null
	item_quantity.text=""
	
	

func set_item(new_item):
	item=new_item
	item_icon.texture=new_item["texture"]
	
	if new_item["quantity"] > 0:
		item_quantity.text = str(new_item["quantity"])
	else:
		item_quantity.text = ""
		
	



func _on_drop_button_pressed() -> void:
	if item != null:
		
		var drop_position= Global.player_Node.global_position
		var drop_offset= Vector2(0,50)
		drop_offset=drop_offset.rotated(Global.player_Node.rotation)
		if item.has("effect")==true:
			Global.drop_weapon(item, drop_position)
			Global.remove_weapon(item["type"],item["id"])
		elif item.has("id")==true:
			Global.drop_weapon(item, drop_position)
			Global.remove_weapon(item["type"],item["id"])
		usage_panel.visible=false 
		


func _on_use_button_pressed() -> void:
	usage_panel.visible=false
	if item != null and item["effect"]!="":
		if Global.player_Node:
			Global.player_Node.apply_item_effect(item)
			Global.remove_item(item["type"],item["effect"])
		else :
			print("player not found")
