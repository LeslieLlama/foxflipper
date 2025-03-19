extends ActiveLuckyCharm

var savedHeads = 0
var savedTails = 0

func _ready() -> void:
	assign_seq_sym()
	charges = maxCharges
	_update_charge_counter()
	Signals.AllCoinsScored.connect(_all_coins_scored)
	Signals.ResetTable.connect(_reset_table)
	Signals.ScoreCoins.connect(_score_coins)
	Signals.FlippedCoin.connect(_coin_flipped)
	Signals.ScoreCoins.connect(_scoring_begins)
	Signals.AllCoinsScored.connect(_scoring_ends)
	
func _active_use():
	if is_enabled == false:
		return
	if is_useable == false:
		return
	print("item activated")
	savedHeads = Globals.headsValue
	savedTails = Globals.tailsValue
	var tempHeads = 0
	var tempTails = 0
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

func _process(_delta: float) -> void:
	if is_enabled == false: 
		return
	if scoring_is_ongoing:
		return
	if mouseHold == true:
		destructionProgress += 1
	else:
		destructionProgress = 0
	$TextureProgressBar.value = destructionProgress
	if destructionProgress >= $TextureProgressBar.max_value:
		Globals.headsValue = savedHeads
		Globals.tailsValue = savedTails
		Signals.emit_signal("UpdateScoreUI")
		Signals.emit_signal("RemoveItem", self)
		queue_free()
	
func _coin_flipped(coinCount):
	if coinCount >= 1 and charges > 0:
		_ready_animation()
		is_useable = true
	
func _all_coins_scored():
	if charges < maxCharges:
		Globals.headsValue = savedHeads
		Globals.tailsValue = savedTails
		Signals.emit_signal("UpdateScoreUI")
		
func _reset_table():
	if is_enabled == true:
		charges = maxCharges
		_update_charge_counter()
		
func _update_charge_counter():
	$ChargeCounter.text = str("🗲",charges)
	

	
