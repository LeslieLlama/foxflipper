extends Control

var rng = RandomNumberGenerator.new()
var coinFullSize : Vector2 = Vector2(0.7,0.7)
var coinFlatSize : Vector2 = Vector2(0.7,0)
var coinTween
@export var CoinTailsSide : TextureRect
@export var CoinHeadsSide : TextureRect
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.FlipCoin.connect(_flip_coin)

func _flip_coin(is_reflip : bool):
	Globals.coinsToThrow -= 1
	if is_reflip == true:
		Globals.CoinHistory.pop_back()
		Globals.coinCount -= 1
	
	var flip_value = rng.randf_range(0, 1)
	if flip_value <= Globals.headsThreshhold:
		_coin_flip_animation(false)
		Globals.CoinHistory.append(0)
		Globals.coinCount += 1
	else: 
		_coin_flip_animation(true)
		Globals.CoinHistory.append(1)
		Globals.coinCount += 1
	Signals.emit_signal("FlippedCoin", Globals.coinCount)
	
func _coin_flip_animation(heads : bool):
	if coinTween:
		if coinTween.is_running() == true: #if the player mashes the flip button, update the history vissually. and kill/restart the tween. 
			_update_coin_history()
		coinTween.kill()
	coinTween = get_tree().create_tween().bind_node(self)
	if heads == true:
		coinTween.tween_property(CoinTailsSide, "scale", coinFlatSize, 0.1).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property(CoinHeadsSide, "scale", coinFullSize, 0.1).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property(CoinHeadsSide, "scale", coinFlatSize, 0.1).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property(CoinTailsSide, "scale", coinFullSize, 0.1).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property(CoinTailsSide, "scale", coinFlatSize, 0.2).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property(CoinHeadsSide, "scale", Vector2(0.8,0.8), 0.1).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property(CoinHeadsSide, "scale", coinFullSize, 0.2).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_callback(_update_coin_history)
	else: 
		coinTween.tween_property(CoinHeadsSide, "scale", coinFlatSize, 0.1).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property(CoinTailsSide, "scale", coinFullSize, 0.1).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property(CoinTailsSide, "scale", coinFlatSize, 0.1).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property(CoinHeadsSide, "scale", coinFullSize, 0.1).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property(CoinHeadsSide, "scale", coinFlatSize, 0.2).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property(CoinTailsSide, "scale", Vector2(0.8,0.8), 0.1).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property(CoinTailsSide, "scale", coinFullSize, 0.2).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_callback(_update_coin_history)
		
func _update_coin_history():
	Signals.emit_signal("CoinHistoryDisplayUpdate")
