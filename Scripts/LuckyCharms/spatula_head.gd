extends ActiveLuckyCharm

func _ready() -> void:
	charges = maxCharges
	_update_charge_counter()
	Signals.ResetTable.connect(_reset_table)
	Signals.ScoreCoins.connect(_score_coins)
	Signals.FlipCoin.connect(_coin_flipped)
	
func _active_use():
	if is_enabled == false:
		return
	if is_useable == false:
		return
	print("item activated")
	if Globals.CoinHistory[Globals.coinCount-1] == 0:
		Globals.CoinHistory[Globals.coinCount-1] = 1
	else: 
		Globals.CoinHistory[Globals.coinCount-1] = 0
	Signals.emit_signal("CoinHistoryDisplayUpdate")
	_activation_animation()
	charges -= 1
	_update_charge_counter()
	
func _coin_flipped(coinCount):
	if coinCount >= 1:
		_ready_animation()
		is_useable = true
	
func _reset_table():
	if is_enabled == true:
		charges = maxCharges
		_update_charge_counter()
		
	
func _update_charge_counter():
	$ChargeCounter.text = str("🗲",charges)
	Description = str(
		"Click this item ",charges," time(s) per turn to flip the previous coin value to the opposite value "
	)
