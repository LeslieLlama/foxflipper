extends Control


@export var itemContainerPrefab : PackedScene 
var itemContainers: Array[ItemContainer] = []

@export var itemList : Array[PackedScene]

func _ready() -> void:
	Signals.Mouse_Over_Shop.connect(_tool_tip_on)
	Signals.Mouse_End_Shop.connect(_tool_tip_off)
	_create_item_container()
	
func _tool_tip_on(iname, desc):
	$Tooltip/VBoxContainer/itemName.text = iname
	$Tooltip/VBoxContainer/itemDescription.text = desc
	
func _tool_tip_off():
	$Tooltip/VBoxContainer/itemName.text = "None"
	$Tooltip/VBoxContainer/itemDescription.text = "Hover over an item to see it's effect and name."
	
func _create_item_container():
	for i in itemList.size():
		var child_node = itemContainerPrefab.instantiate()
		child_node.is_shop = false
		$Panel/GridContainer.add_child(child_node)
		itemContainers.append(child_node)
		var newItem = itemList[i].instantiate()
		child_node.NewItem(newItem)
		newItem.queue_free()
