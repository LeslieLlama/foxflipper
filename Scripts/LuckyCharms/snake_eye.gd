extends LuckyCharm


func AddToScore(coinValues = []):
	print("SnakeEyeTrigger!")
	pattern_finder()
	return coinValues
	
func pattern_finder():
	var runCount = 0
	var previousCoinValue = -1
	var highestRunCount = 1
	var runArray = []
	
	for c in Globals.CoinHistory.size():
		await get_tree().create_timer(0.1).timeout
		if Globals.CoinHistory[c] == previousCoinValue || c==0:
			runCount += 1
			runArray.append(Globals.CoinHistory[c])
		else: 
			#run is broken
			if Globals.CoinHistory[c-1] == 0: #tails
				pattern_payoff(runCount, runArray,c,colorBlue)
			else: #heads
				pattern_payoff(runCount, runArray,c,colorRed)
			runCount = 1
			runArray.clear()
			runArray.append(Globals.CoinHistory[c])
		previousCoinValue = Globals.CoinHistory[c]
		
func pattern_payoff(runCount : int, runArray, c : int, colorToUse : Color):
	if runCount == 1:
		await get_tree().create_timer(0.2).timeout
		_activation_animation()
		print("runcount of 1")
		
