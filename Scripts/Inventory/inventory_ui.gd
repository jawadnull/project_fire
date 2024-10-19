extends Control# inventory ui

@onready var grid_container: GridContainer = $ScrollContainer/MarginContainer/GridContainer

@onready var item_effect: Label = $"../details/ItemEffect"
@onready var item_name: Label = $"../details/ItemName"
@onready var item_type: Label = $"../details/ItemType"
@onready var details_icon: Sprite2D = $"../details/detailsIcon"


var item=null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.Inventory_Updated.connect(on_inventory_update)
	on_inventory_update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_inventory_update():
	clear_grid_container()
	
	for item in Global.Inventory:
		var slot=Global.Inventory_slot_scene.instantiate()
		grid_container.add_child(slot)
		
		# Connect the mouse enter signal from the slot to this scene
		slot.mouse_entered_item.connect(self._on_slot_item_mouse_entered)
		
		if item != null:
			slot.set_item(item)
			set_item(item)
		else:
			slot.set_empty()
	

func clear_grid_container():
	while grid_container.get_child_count()>0:
		var child=grid_container.get_child(0)
		grid_container.remove_child(child)
		child.queue_free()

func _on_slot_item_mouse_entered(new_item):
	if item["name"] != new_item["name"]:
		set_item(new_item)


func set_item(new_item):
	
	item=new_item
	details_icon.texture=new_item["texture"]
	
		
	item_name.text=str(item["name"])
	item_type.text=str(item["type"])
	
	if item["effect"] !="":
		item_effect.text=str("+ ",item["effect"])
	else:
		item_effect.text=""
