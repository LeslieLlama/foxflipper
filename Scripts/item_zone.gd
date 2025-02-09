extends Control

@export var Item1Description : PanelContainer
@export var Item2Description : PanelContainer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Item1Description.hide()
	Item2Description.hide()


#Display Item Description when hovered
func _on_item_1_mouse_entered() -> void:
	Item1Description.show()
func _on_item_1_mouse_exited() -> void:
	Item1Description.hide()
func _on_item_2_mouse_entered() -> void:
	Item2Description.show()
func _on_item_2_mouse_exited() -> void:
	Item2Description.hide()
