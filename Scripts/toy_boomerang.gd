extends LuckyCharm

	
func MultiplyScore():
	print("boomerang trigger")
	Globals.currentScore *= 2
	_activation_animation()
	Signals.emit_signal("AddPointsToCoin") #for now use the add points to coin sound
	#coinValues[c] = coinValues[c] + (Globals.headsValue * heads_count)
	#var pos : Vector2 = Vector2(Globals.CoinHistorySprites[(c)].global_position.x,Globals.CoinHistorySprites[(c)].global_position.y+40)
	#var new_pos : Vector2 = Vector2(pos.x, pos.y+50)
	#Signals.emit_signal("PopupMessage", str(coinValues[c]),pos,new_pos,colorBlue)
