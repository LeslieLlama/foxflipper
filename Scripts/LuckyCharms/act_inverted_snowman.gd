extends ActiveLuckyCharm

func _ready() -> void:
	assign_seq_sym()
	charges = maxCharges
	_update_charge_counter()
	Signals.ResetTable.connect(_reset_table)
	Signals.ScoreCoins.connect(_score_coins)
	Signals.FlippedCoin.connect(_coin_flipped)
	
func _active_use():
	if is_enabled == false:
		return
	if is_useable == false:
		return
	print("item activated")
	var tempHeads = 0
	var tempTails = 0
	#print(str("remainder experiment: ", (15%2)))
	Globals.headsValue *=2
	Globals.tailsValue *=2
	tempHeads = Globals.headsValue
	tempTails = Globals.tailsValue
	Globals.headsValue = tempTails
	Globals.tailsValue = tempHeads
	Signals.emit_signal("UpdateScoreUI")
	_activation_animation()
	charges -= 1
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
		"Click this item to reflip the last flipped coin, ",charges," times per round"
	)
