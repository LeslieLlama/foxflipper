extends LuckyCharm

class_name ActiveLuckyCharm

@export var charges = 0
@export var maxCharges = 0
var is_useable : bool = false
func _ready() -> void:
	charges = maxCharges
	_update_charge_counter()
	Signals.ScoreCoins.connect(_scoring_begins)
	Signals.AllCoinsScored.connect(_scoring_ends)
	Signals.ResetTable.connect(_reset_table)
	Signals.ScoreCoins.connect(_score_coins)
	assign_seq_sym()

func _on_mouse_entered() -> void:
	Signals.emit_signal("Mouse_Over", Name, Description)

func _on_mouse_exited() -> void:
	if not Rect2(Vector2(), self.size).has_point(get_viewport().get_mouse_position()):
		Signals.emit_signal("Mouse_End")
		
func _reset_table():
	if is_enabled == true:
		_ready_animation()
		charges = maxCharges
		_update_charge_counter()
		is_useable = true
	
func _score_coins():
	is_useable = false
	if tween:
		tween.kill()
	
func _update_charge_counter():
	$ChargeCounter.text = str("🗲",charges)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT :
			mouseHold = true
	if event is InputEventMouseButton and event.pressed == false:
		if event.button_index == MOUSE_BUTTON_LEFT :
			_active_use()
			mouseHold = false
			
func _active_use():
	if charges <= 0:
		return
	if is_enabled == false:
		return
	if is_useable == false:
		return
	print("item activated")
	_activation_animation()
	charges -= 1
	_update_charge_counter()
	
func _ready_animation():
	if tween:
		tween.kill()
	tween = get_tree().create_tween().bind_node(self).set_loops()
	tween.tween_property($TextureRect, "rotation_degrees", -5, 1).set_trans(Tween.TRANS_SINE)
	tween.chain().tween_property($TextureRect, "rotation_degrees", 5, 1).set_trans(Tween.TRANS_SINE)
