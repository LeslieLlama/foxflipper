extends LuckyCharm


func AddToScore(coinValues = []):
	var runCount = 0
	var previousCoinValue = -1
	var runArray = []
	for c in Globals.CoinHistory.size():
		if Globals.CoinHistory[c] == previousCoinValue || c==0:
			runCount += 1
			runArray.append(Globals.CoinHistory[c])
		else: 
			#run is broken
			if runCount >= 3 && Globals.CoinHistory[c] == 0:
				await get_tree().create_timer(0.2).timeout
				_activation_animation()
				var collective = 0
				for i in runCount:
					Signals.emit_signal("MiniCoinAnimation",(c-1)-i)
					collective += Globals.CoinValues[c-1-i]
				var scoreToAdd = runCount * collective
				Globals.currentScore += scoreToAdd
				var middleOfArray = c - (runArray.size()-(runArray.size()/2))
				Signals.emit_signal("ComboScored")
				var pos : Vector2 = Vector2(Globals.CoinHistorySprites[middleOfArray].global_position.x,Globals.CoinHistorySprites[middleOfArray].global_position.y-10)
				var new_pos : Vector2 = Vector2(pos.x, pos.y-30)
				Signals.emit_signal("PopupMessage",(str("Run! +",scoreToAdd,"!")), pos,new_pos, colorRed)
			runCount = 1
			runArray.clear()
			runArray.append(Globals.CoinHistory[c])
		previousCoinValue = Globals.CoinHistory[c]
	return coinValues
