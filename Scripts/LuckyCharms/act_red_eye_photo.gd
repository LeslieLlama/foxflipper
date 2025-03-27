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
	
	Signals.emit_signal("ResetTable")
	Globals.currentScore = 0
	Globals.CoinHistory.clear()
	Globals.coinCount = 0
	Globals.coinsToThrow = Globals.maxCoinCount
	
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
		"Click this charm to return all coins and clear coin history (once per round)"
	)
