extends Panel

class_name ItemContainer
signal itemBought
@export var item : LuckyCharm


func NewItem(newItem : LuckyCharm):
	var child_node = newItem.duplicate()
	$HBoxContainer.add_child(child_node)
	$HBoxContainer.move_child(child_node, 0)
	item.queue_free()
	item = child_node
	child_node.show()
	
func _add_item():
	if Globals.itemNum < 2:
		Signals.emit_signal("PurchaseItem", item)
		emit_signal("itemBought")
	else: 
		Signals.emit_signal("PopupMessage", "Inventory Full!", global_position, global_position, Color("D0665A"))
