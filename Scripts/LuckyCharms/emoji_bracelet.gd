extends LuckyCharm

func AddToScore(coinValues = []):
	for c in Globals.CoinHistory.size():
		if Globals.CoinHistory[c] == 0:
			continue
		await get_tree().create_timer(0.1).timeout
		if c-1 >= 0:
			if Globals.CoinHistory[c-1] == 1:
				coinValues[c] += 30
		if c != Globals.CoinHistory.size()-1:
			if Globals.CoinHistory[c+1] == 1:
				coinValues[c] += 30
		Flair(c, coinValues)
	return coinValues
	
func Flair(c, coinValues):
	_activation_animation()
	Signals.emit_signal("AddPointsToCoin")
	var pos : Vector2 = Vector2(Globals.CoinHistorySprites[(c)].global_position.x,Globals.CoinHistorySprites[(c)].global_position.y+40)
	var new_pos : Vector2 = Vector2(pos.x, pos.y+50)
	Signals.emit_signal("PopupMessage", str(coinValues[c]),pos,new_pos,colorRed)
	
