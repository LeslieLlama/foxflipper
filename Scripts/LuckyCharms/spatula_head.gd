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
	if Globals.CoinHistory[Globals.coinCount-1] == 0: #tails
		Globals.coinsToThrow += 1
		var current_heads_threshhold = Globals.headsThreshhold
		Globals.headsThreshhold = 0
		Signals.emit_signal("FlipCoin", true)
		Globals.headsThreshhold = current_heads_threshhold
	else: #heads
		Globals.coinsToThrow += 1
		var current_heads_threshhold = Globals.headsThreshhold
		Globals.headsThreshhold = 100
		Signals.emit_signal("FlipCoin", true)
		Globals.headsThreshhold = current_heads_threshhold
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
		"Click this item, ",charges," time(s) per turn to flip the previous coin value to the opposite value "
	)
