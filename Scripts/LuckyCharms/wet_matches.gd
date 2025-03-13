extends LuckyCharm


func AddToScore(coinValues = []):
	#print("Wet Match Trigger!")
	coinValues = await coin_pattern_searcher(coinValues)
	return coinValues
	
func coin_pattern_searcher(coinValues = []):
	var runCount = 0
	var previousCoinValue = -1
	var runArray = []
	
	for c in Globals.CoinHistory.size():
		await get_tree().create_timer(0.1).timeout
		if Globals.CoinHistory[c] == previousCoinValue || c==0:
			runCount += 1
			runArray.append(Globals.CoinHistory[c])
		else: 
			#run is broken
			if Globals.CoinHistory[c-1] == 0: #tails
				await pattern_payoff(runCount, runArray,c,coinValues)
			runCount = 1
			runArray.clear()
			runArray.append(Globals.CoinHistory[c])
		previousCoinValue = Globals.CoinHistory[c]
		if c+1 == Globals.CoinHistory.size():
			if Globals.CoinHistory[c] == 0: #tails
				await pattern_payoff(runCount, runArray,c+1, coinValues)
			runCount = 1
			runArray.clear()
	return coinValues
	
func pattern_payoff(runCount : int, runArray, c : int, coinValues = []):
	if runCount >= 3:
		#print(str("run array : ",runArray))
		for a in runArray.size():
			await get_tree().create_timer(0.2).timeout
			_activation_animation()
			Signals.emit_signal("AddPointsToCoin") 
			coinValues[c-1-a] *= (float(runCount)/2)
			var pos : Vector2 = Vector2(Globals.CoinHistorySprites[(c-1-a)].global_position.x,Globals.CoinHistorySprites[(c-1-a)].global_position.y+40)
			var new_pos : Vector2 = Vector2(pos.x, pos.y+50)
			Signals.emit_signal("PopupMessage", str(coinValues[c-1-a]),pos,new_pos,colorBlue)
	
