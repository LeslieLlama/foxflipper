extends LuckyCharm


func AddToScore(coinValues = []):
	print("BottlecapTrigger!")
	if Globals.CoinHistory[Globals.CoinHistory.size()-1] == 1:
		await get_tree().create_timer(0.2).timeout
		_activation_animation()
		Signals.emit_signal("AddPointsToCoin")
		print("+1000 to last heads")
		coinValues[Globals.CoinHistory.size()-1] += 1000
		var pos : Vector2 = Vector2(Globals.CoinHistorySprites[(Globals.CoinHistory.size()-1)].global_position.x,Globals.CoinHistorySprites[(Globals.CoinHistory.size()-1)].global_position.y+40)
		var new_pos : Vector2 = Vector2(pos.x, pos.y+50)
		Signals.emit_signal("PopupMessage", str(coinValues[Globals.CoinHistory.size()-1]),pos,new_pos,colorRed)
	return coinValues
