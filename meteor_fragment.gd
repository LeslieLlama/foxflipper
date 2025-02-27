extends LuckyCharm

#I'd like this to be an item that rewards flipping against the odds, I feel like the reward could be more dramatic though. like flipping a 1% chance coin should award crazy points, not +99. 
func AddToScore(coinValues = []):
	for c in Globals.CoinHistory.size():
		await get_tree().create_timer(0.1).timeout
		var pos : Vector2 = Vector2(Globals.CoinHistorySprites[(c)].global_position.x,Globals.CoinHistorySprites[(c)].global_position.y+40)
		var new_pos : Vector2 = Vector2(pos.x, pos.y+50)
		if Globals.CoinHistory[c] == 1: #heads
			coinValues[c] += (Globals.headsThreshhold*100)
			Signals.emit_signal("PopupMessage", str(coinValues[c]),pos,new_pos,colorRed)
		else: #tails
			coinValues[c] += (100-(Globals.headsThreshhold*100))
			Signals.emit_signal("PopupMessage", str(coinValues[c]),pos,new_pos,colorBlue)
		_activation_animation()
		Signals.emit_signal("AddPointsToCoin")
		
	return coinValues
