extends LuckyCharm


func AddToScore(coinValues = []):
	for c in Globals.CoinHistory.size():
		await get_tree().create_timer(0.1).timeout
		print("UFO Trigger!")
		_activation_animation()
		coinValues[c] += 50
		Signals.emit_signal("AddPointsToCoin")
		var pos : Vector2 = Vector2(Globals.CoinHistorySprites[(c)].global_position.x,Globals.CoinHistorySprites[(c)].global_position.y+40)
		var new_pos : Vector2 = Vector2(pos.x, pos.y+50)
		Signals.emit_signal("PopupMessage", str(coinValues[c]),pos,new_pos,colorRed)
	return coinValues
	
