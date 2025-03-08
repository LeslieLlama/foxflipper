extends Node

class_name LuckyCharm

@export var Name : String
@export var Icon : Texture2D
@export_multiline var Description : String
@export var SequenceSymbol : Label
##determines how likely an item is to show up in the shop. 1 is the base, 2 would be twice as likely to show up. 
@export var rarity = 1
@export var itemSlot = 0
var tween
var colorRed = Color("D0665A")
var colorBlue = Color("65A7C1")
var mouseHold : bool = false
var destructionProgress = 0
var is_enabled = false


@export var current_type = Globals.item_type.ADDITION

func _ready() -> void:
	assign_seq_sym()

func ImmediateEffect():
	print("activating pre-wager item effect")

func AddToScore(coinValues = []):
	print("coin values accepted!")
	return coinValues
	
func MultiplyScore():
	print("multiplying score by condition...")
	
func _process(_delta: float) -> void:
	if is_enabled == false: 
		return
	if mouseHold == true:
		destructionProgress += 1
	else:
		destructionProgress = 0
	$TextureProgressBar.value = destructionProgress
	if destructionProgress >= $TextureProgressBar.max_value:
		Signals.emit_signal("RemoveItem", self)
		queue_free()
	
func _on_mouse_entered() -> void:
	Signals.emit_signal("Mouse_Over", Name, Description)

func _on_mouse_exited() -> void:
	if not Rect2(Vector2(), self.size).has_point(get_viewport().get_mouse_position()):
		Signals.emit_signal("Mouse_End")
	
func item_enabled(val : bool):
	is_enabled = val
	
func _activation_animation():
	if tween:
		tween.kill()
	tween = get_tree().create_tween().set_parallel(true).bind_node(self)
	tween.tween_property($TextureRect, "rotation_degrees", -20, 0.1).set_trans(Tween.TRANS_SPRING)
	tween.tween_property($TextureRect, "scale", Vector2(1.3,1.3), 0.1).set_trans(Tween.TRANS_SINE)
	tween.chain().tween_property($TextureRect, "rotation_degrees", 0, 0.1).set_trans(Tween.TRANS_SPRING)
	tween.tween_property($TextureRect, "scale", Vector2(1,1), 0.1).set_trans(Tween.TRANS_SINE)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT :
			mouseHold = true
	if event is InputEventMouseButton and event.pressed == false:
		if event.button_index == MOUSE_BUTTON_LEFT :
			mouseHold = false
			
#IMMEDIATE, ADDITION, POST_RUN, UTILITY
func assign_seq_sym():
	match current_type:
		Globals.item_type.IMMEDIATE:
			SequenceSymbol.text = "!"
		Globals.item_type.ADDITION:
			SequenceSymbol.text = "#"
		Globals.item_type.POST_RUN:
			SequenceSymbol.text = "*"
		Globals.item_type.UTILITY:
			SequenceSymbol.text = "@"
		
