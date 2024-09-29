extends Node2D# main Node


@onready var items: Node2D = $Items
@onready var items_spwan_area: Area2D = $ItemsSpwanArea
@onready var collision_shape: CollisionShape2D = $ItemsSpwanArea/CollisionShape2D



func _ready() -> void:
	spwan_random_items(10)

func get_random_position():
	var area_rect= collision_shape.shape.get_rect()
	var x=randf_range(0,area_rect.position.x)
	var y=randf_range(area_rect.position.y,0)
	return items_spwan_area.to_global(Vector2(x,y))
	


func spwan_random_items(count):
	var attempts=0
	var spawned_count=0
	
	while spawned_count<count and attempts <100:
		var position = get_random_position()
		spwan_item(Global.spawnble_items[randi() % Global.spawnble_items.size()],position)
		spawned_count+=1
		attempts+=1
		
	


func spwan_item(data,position):
	var item_scene=preload("res://Scenes/Inventory/item.tscn")
	var item_instance= item_scene.instantiate()
	item_instance.initiate_items(data["type"],data["name"],data["effect"],data["texture"],data["quantity"])
	item_instance.global_position=position
	items.add_child(item_instance)
