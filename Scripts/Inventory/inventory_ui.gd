extends Control

@onready var grid_container: GridContainer = $GridContainer

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
		
		if item != null:
			slot.set_item(item)
		else:
			slot.set_empty()
	

func clear_grid_container():
	while grid_container.get_child_count()>0:
		var child=grid_container.get_child(0)
		grid_container.remove_child(child)
		child.queue_free()
