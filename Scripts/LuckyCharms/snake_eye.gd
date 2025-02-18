extends LuckyCharm


func AddToScore(coinValues = []):
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
			if runCount >= 3:
				await get_tree().create_timer(0.2).timeout
				_activation_animation()
				Signals.emit_signal("AddPointsToCoin")
				coinValues[c] += 200
				var pos : Vector2 = Vector2(Globals.CoinHistorySprites[(c)].global_position.x,Globals.CoinHistorySprites[(c)].global_position.y+40)
				var new_pos : Vector2 = Vector2(pos.x, pos.y+50)
				var newCol : Color
				if Globals.CoinHistory[c] == 1 : newCol = colorRed 
				else: newCol = colorBlue
				Signals.emit_signal("PopupMessage", str(coinValues[c]),pos,new_pos,newCol)
				print("SnakeEyeTrigger!")
			runCount = 1
			runArray.clear()
			runArray.append(Globals.CoinHistory[c])
		previousCoinValue = Globals.CoinHistory[c]
	return coinValues
