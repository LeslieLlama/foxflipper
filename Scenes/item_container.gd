extends Panel

class_name ItemContainer

@export var item : LuckyCharm
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func NewItem(newItem : LuckyCharm):
	#item = newItem
	#SetDisplay()
	var child_node = newItem.duplicate()
	$HBoxContainer.add_child(child_node)
	$HBoxContainer.move_child(child_node, 0)
	item.queue_free()
	item = child_node
	child_node.show()
	
func _add_item():
	Signals.emit_signal("PurchaseItem", item)
