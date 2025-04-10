extends Control

class_name ItemContainer
signal itemBought
@export var item : LuckyCharm

var is_shop = true

func _ready() -> void:
	if item != null:
		$Button.icon = item.Icon
		$Label.text = item.Name
		$Label2.text = item.Name

func NewItem(newItem : LuckyCharm):
	var child_node = newItem.duplicate()
	self.add_child(child_node)
	self.move_child(child_node, 0)
	if item != null:
		item.queue_free()
	item = child_node
	$Button.icon = child_node.Icon
	#$Button.text = child_node.Name
	$Label2.text = match_seq_sym(child_node.current_type)
	$Label.text = child_node.Name
	item.visible = false
	
func _add_item():
	if is_shop == false:
		return
	if Globals.itemNum < 2:
		Signals.emit_signal("PurchaseItem", item)
		emit_signal("itemBought")
	else: 
		Signals.emit_signal("PopupMessage", "Inventory Full!", global_position, global_position, Color("D0665A"))
		
func _disable_buy_button(val : bool):
	$Button.disabled = val
	
func _on_mouse_entered() -> void:
	Signals.emit_signal("Mouse_Over_Shop", item.Name, item.Description)

func _on_mouse_exited() -> void:
	if not Rect2(Vector2(), self.size).has_point(get_viewport().get_mouse_position()):
		Signals.emit_signal("Mouse_End_Shop")
		
#IMMEDIATE, ADDITION, POST_RUN, UTILITY
func match_seq_sym(current_type):
	match current_type:
		Globals.item_type.IMMEDIATE:
			return "!"
		Globals.item_type.ADDITION:
			return "#"
		Globals.item_type.POST_RUN:
			return "*"
		Globals.item_type.UTILITY:
			return "@"
