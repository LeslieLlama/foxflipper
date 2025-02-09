extends LuckyCharm


func AddToScore(coinValues = []):
	print("UmbrellaTrigger!")
	var heads_count : int = 0
	for c in Globals.CoinHistory.size():
		if Globals.CoinHistory[c] == 1:
			heads_count += 1
	for c in Globals.CoinHistory.size():
		if Globals.CoinHistory[c] == 0:
			await get_tree().create_timer(0.2).timeout
			_activation_animation()
			Signals.emit_signal("AddPointsToCoin")
			coinValues[c] = coinValues[c] + (150 * heads_count)
			var pos : Vector2 = Vector2(Globals.CoinHistorySprites[(c)].global_position.x,Globals.CoinHistorySprites[(c)].global_position.y+40)
			var new_pos : Vector2 = Vector2(pos.x, pos.y+50)
			Signals.emit_signal("PopupMessage", str(coinValues[c]),pos,new_pos,colorBlue)
	return coinValues
