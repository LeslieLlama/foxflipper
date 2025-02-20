extends LuckyCharm


func AddToScore(coinValues = []):
	for c in Globals.CoinHistory.size():
		if check_values(c, coinValues) == true:
			await get_tree().create_timer(0.2).timeout
			print("Switchblade Comb Trigger!")
			_activation_animation()
			coinValues[c] += 200
			Signals.emit_signal("AddPointsToCoin")
			var pos : Vector2 = Vector2(Globals.CoinHistorySprites[(c)].global_position.x,Globals.CoinHistorySprites[(c)].global_position.y+40)
			var new_pos : Vector2 = Vector2(pos.x, pos.y+50)
			Signals.emit_signal("PopupMessage", str(coinValues[c]),pos,new_pos,colorBlue)
	return coinValues
	
func check_values(c,coinValues = []):
	if c-1 < 0 or c == Globals.CoinHistory.size()-1:
		return false
	if Globals.CoinHistory[c-1] == Globals.CoinHistory[c]:
		return false
	if Globals.CoinHistory[c+1] == Globals.CoinHistory[c]:
		return false
	return true
	
