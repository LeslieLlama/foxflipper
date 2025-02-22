extends LuckyCharm

@export var counter : Label
func _ready() -> void:
	Signals.NextRound.connect(_next_round)
	counter.text = ""

func AddToScore(coinValues = []):
	print("UmbrellaTrigger!")
	var tails_count : int = 0
	for c in Globals.CoinHistory.size():
		if Globals.CoinHistory[c] == 0:
			tails_count += 1
			counter.text = str("x",tails_count/2)
	if tails_count == 0: return coinValues
	for c in Globals.CoinHistory.size():
		if Globals.CoinHistory[c] == 0:
			await get_tree().create_timer(0.2).timeout
			_activation_animation()
			Signals.emit_signal("AddPointsToCoin")
			coinValues[c] = (coinValues[c] * (tails_count/2))
			var pos : Vector2 = Vector2(Globals.CoinHistorySprites[(c)].global_position.x,Globals.CoinHistorySprites[(c)].global_position.y+40)
			var new_pos : Vector2 = Vector2(pos.x, pos.y+50)
			Signals.emit_signal("PopupMessage", str(coinValues[c]),pos,new_pos,colorBlue)
			#skip the combo step?
	return coinValues
	
func _next_round():
	counter.text = ""
