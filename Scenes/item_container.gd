extends Panel

class_name ItemContainer
signal itemBought
@export var item : LuckyCharm


func NewItem(newItem : LuckyCharm):
	var child_node = newItem.duplicate()
	self.add_child(child_node)
	self.move_child(child_node, 0)
	if item != null:
		item.queue_free()
	item = child_node
	$Button.icon = child_node.Icon
	#$Button.text = child_node.Name
	$Label.text = child_node.Name
	$Label2.text = child_node.Name
	
func _add_item():
	if Globals.itemNum < 2:
		Signals.emit_signal("PurchaseItem", item)
		emit_signal("itemBought")
	else: 
		Signals.emit_signal("PopupMessage", "Inventory Full!", global_position, global_position, Color("D0665A"))
		
func _disable_buy_button(val : bool):
	$Button.disabled = val
