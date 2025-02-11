extends Panel

class_name ItemContainer

var item : LuckyCharm
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func NewItem(newItem : LuckyCharm):
	item = newItem
	SetDisplay()

func SetDisplay():
	$HBoxContainer/Control/ItemName.text = item.Name
	$HBoxContainer/Control/TextureRect.texture = item.Icon
