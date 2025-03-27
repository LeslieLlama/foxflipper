extends ActiveLuckyCharm

func _ready() -> void:
	assign_seq_sym()
	charges = maxCharges
	_update_charge_counter()
	Signals.ResetTable.connect(_reset_table)
	Signals.ScoreCoins.connect(_score_coins)
	Signals.FlippedCoin.connect(_coin_flipped)
	
func _active_use():
	if charges <= 0:
		return
	if is_enabled == false:
		return
	if is_useable == false:
		return
	print("item activated")
	charges -= 1
	Signals.emit_signal("ForceTriggerItems")
	#Signals.emit_signal("ScoreCoins")
	_activation_animation()
	_update_charge_counter()
	
func _coin_flipped(coinCount):
	if coinCount >= 1 and charges > 0:
		_ready_animation()
		is_useable = true
	
func _reset_table():
	if is_enabled == true:
		charges = maxCharges
		_update_charge_counter()
	
func _update_charge_counter():
	$ChargeCounter.text = str("🗲",charges)
	Description = str(
		"Click this item once per round to force-activate other item(s), and immediately end the round."
	)
	
func _activation_animation():
	if tween:
		tween.kill()
	tween = get_tree().create_tween().set_parallel(true).bind_node(self)
	tween.tween_property($TextureRect, "rotation_degrees", -20, 0.1).set_trans(Tween.TRANS_SPRING)
	tween.tween_property($TextureRect, "scale", Vector2(1.3,1.3), 0.1).set_trans(Tween.TRANS_SINE)
	tween.chain().tween_property($TextureRect, "rotation_degrees", 0, 0.1).set_trans(Tween.TRANS_SPRING)
	tween.tween_property($TextureRect, "scale", Vector2(1,1), 0.1).set_trans(Tween.TRANS_SINE)
	tween.chain().tween_callback(_coin_flipped.bind(Globals.coinCount))
