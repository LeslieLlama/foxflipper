extends Node

class_name LuckyCharm

@export var Name : String
@export var Icon : Texture2D
@export var Description : String
@export var DescriptionPanel : PanelContainer
var tween
var colorRed = Color("D0665A")
var colorBlue = Color("65A7C1")

func _ready() -> void:
	$ItemDescription/VBoxContainer/Label.text = Name
	$ItemDescription/VBoxContainer/Label2.text = Description
	$TextureRect.texture = Icon
func AddToScore(coinValues = []):
	print("coin values accepted!")
	_activation_animation()
	return coinValues
	
func _on_mouse_entered() -> void:
	DescriptionPanel.show()

func _on_mouse_exited() -> void:
	DescriptionPanel.hide()
	
func _activation_animation():
	if tween:
		tween.kill()
	tween = get_tree().create_tween().set_parallel(true).bind_node(self)
	tween.tween_property($TextureRect, "rotation_degrees", -20, 0.1).set_trans(Tween.TRANS_SPRING)
	tween.tween_property($TextureRect, "scale", Vector2(1.3,1.3), 0.1).set_trans(Tween.TRANS_SINE)
	tween.chain().tween_property($TextureRect, "rotation_degrees", 0, 0.1).set_trans(Tween.TRANS_SPRING)
	tween.tween_property($TextureRect, "scale", Vector2(1,1), 0.1).set_trans(Tween.TRANS_SINE)
