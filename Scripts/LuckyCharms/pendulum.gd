extends LuckyCharm

func AddToScore(coinValues = []):
	
	for c in Globals.CoinHistory.size():
		if itemSlot == 0:  #left slot, coin is tails 
			if Globals.CoinHistory[c] == 0:
				await _AddThePoints(c, colorBlue, coinValues)
			if Globals.itemNum <= 1: #secret effect, if the item is in the middle of two slots it gets both effects.
				if Globals.CoinHistory[c] == 1: #coin is heads 
					await _AddThePoints(c, colorRed, coinValues)
		else: #right or other slot
			if Globals.CoinHistory[c] == 1: #coin is heads 
				await _AddThePoints(c, colorRed, coinValues)
	return coinValues
	
	
func _AddThePoints(c, colorToUse : Color = Color.WHITE, coinValues = []):
	await get_tree().create_timer(0.1).timeout
	print("Pendulum Trigger!")
	_activation_animation()
	coinValues[c] *= 2
	Signals.emit_signal("AddPointsToCoin")
	var pos : Vector2 = Vector2(Globals.CoinHistorySprites[(c)].global_position.x,Globals.CoinHistorySprites[(c)].global_position.y+40)
	var new_pos : Vector2 = Vector2(pos.x, pos.y+50)
	Signals.emit_signal("PopupMessage", str(coinValues[c]),pos,new_pos,colorToUse)
