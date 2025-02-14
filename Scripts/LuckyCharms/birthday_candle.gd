extends LuckyCharm


func AddToScore(coinValues = []):
	print("CandleTrigger!")
	var cancel_count : int = 0
	if Globals.coinsToThrow + Globals.coinCount != Globals.maxCoinCount:
		cancel_count = ((Globals.coinsToThrow + Globals.coinCount) - Globals.maxCoinCount)*-1
	if cancel_count == 0: return coinValues
	for c in Globals.CoinHistory.size():
		await get_tree().create_timer(0.2).timeout
		_activation_animation()
		Signals.emit_signal("AddPointsToCoin")
		coinValues[c] = coinValues[c] * (cancel_count)
		print(str("cancel count: ",cancel_count))
		var pos : Vector2 = Vector2(Globals.CoinHistorySprites[(c)].global_position.x,Globals.CoinHistorySprites[(c)].global_position.y+40)
		var new_pos : Vector2 = Vector2(pos.x, pos.y+50)
		Signals.emit_signal("PopupMessage", str(coinValues[c]),pos,new_pos,Color.DEEP_PINK)
	return coinValues
