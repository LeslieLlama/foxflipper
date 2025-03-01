extends Control

@export var items : Array[LuckyCharm] = []

var colorRed = Color("D0665A")
var colorBlue = Color("65A7C1")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.ScoreCoins.connect(scoring_sequence)
	Signals.PurchaseItem.connect(add_item)
	Signals.RemoveItem.connect(_remove_item)
	Signals.ResetGame.connect(_reset_game)
	Signals.ResetTable.connect(_reset_table)

func _reset_game():
	for i in items:
		i.queue_free()
	items.clear()
	Globals.itemNum = 0
	
func _reset_table():
	Globals.CoinValues.clear()

func add_item(new_item : Control):
	#if items.size() >= 2:
		#Signals.emit_signal("PopupMessage", "Inventory Full!", global_position, global_position, colorRed)
	if items.size() < 2:
		var child_node = new_item.duplicate()
		self.add_child(child_node)
		items.append(child_node)
		child_node.show()
		child_node.item_enabled(true)
		Globals.itemNum += 1

func _remove_item(_item : Control):
	items.erase(_item)
	Globals.itemNum -= 1

#surely there has to be a better way to change the order of a functions operation based on a bool than this branching if statement. 
func scoring_sequence():
	var y = 0
	if Globals.reverse_score_direction == true:
		while y < Globals.score_loop:
			for i in items: 
				if i != null and i.current_type == Globals.item_type.POST_RUN:
					await i.MultiplyScore()
			for i in items:
				if i != null and i.current_type == Globals.item_type.ADDITION:
					Globals.CoinValues = await i.AddToScore(Globals.CoinValues)
			for i in items: #nested loops seems like it could induce overhead, but since the current item max is like, two, I think it's fine. 
				if i != null and i.current_type == Globals.item_type.IMMEDIATE:
					await i.ImmediateEffect()
			Globals.CoinValues = await add_wager_to_coins()
			await coin_pattern_searcher()
			y += 1
	else:
		while y < Globals.score_loop:
			for i in items: 
				if i != null and i.current_type == Globals.item_type.IMMEDIATE:
					await i.ImmediateEffect()
			Globals.CoinValues = await add_wager_to_coins()
			for i in items:
				if i != null and i.current_type == Globals.item_type.ADDITION:
					Globals.CoinValues = await i.AddToScore(Globals.CoinValues)
			await coin_pattern_searcher()
			for i in items: 
				if i != null and i.current_type == Globals.item_type.POST_RUN:
					await i.MultiplyScore()
			y += 1
	Signals.emit_signal("AllCoinsScored")
	
func add_wager_to_coins():
	Globals.CoinValues.clear()
	for c in Globals.CoinHistory.size():
		await get_tree().create_timer(0.1).timeout
		var coin = 0
		if Globals.reverse_score_direction == false:
			coin = (Globals.CoinHistory.size()-1) - c
		else: 
			coin = c
		#var negative_c = (Globals.CoinHistory.size()-1) - c
		var pos : Vector2 = Vector2(Globals.CoinHistorySprites[(coin)].global_position.x,Globals.CoinHistorySprites[(coin)].global_position.y+40)
		var new_pos : Vector2 = Vector2(pos.x, pos.y+50)
		if Globals.CoinHistory[coin] == 0: #tails
			Globals.CoinValues.append(Globals.tailsValue)
			Signals.emit_signal("PopupMessage", str(Globals.CoinValues[c]),pos,new_pos,colorBlue)
		else: #heads
			Globals.CoinValues.append(Globals.headsValue)
			Signals.emit_signal("PopupMessage", str(Globals.CoinValues[c]),pos,new_pos,colorRed)
		Signals.emit_signal("MiniCoinAnimation",coin)
		Signals.emit_signal("AddPointsToCoin")
	await get_tree().create_timer(0.3).timeout
	return Globals.CoinValues

func coin_pattern_searcher():
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
				pattern_payoff(runCount, runArray,c,colorBlue)
			else: #heads
				pattern_payoff(runCount, runArray,c,colorRed)
			runCount = 1
			runArray.clear()
			runArray.append(Globals.CoinHistory[c])
		previousCoinValue = Globals.CoinHistory[c]
		if c+1 == Globals.CoinHistory.size():
			await get_tree().create_timer(0.1).timeout
			print("last coin")
			if Globals.CoinHistory[c] == 0: #tails
				pattern_payoff(runCount, runArray,c+1, colorBlue)
			else: #heads
				pattern_payoff(runCount, runArray,c+1,colorRed)
			runCount = 1
			runArray.clear()
	
	print(str("Coin Values : ",Globals.CoinValues))
	
func pattern_payoff(runCount : int, runArray, c : int, colorToUse : Color):
	for a in runArray:
		pass
	if runCount < 3:
		for i in runCount:
			var pos : Vector2 = Vector2(Globals.CoinHistorySprites[(c-1-i)].global_position.x,Globals.CoinHistorySprites[(c-1-i)].global_position.y-10)
			var new_pos : Vector2 = Vector2(pos.x, pos.y-30)
			Globals.currentScore += Globals.CoinValues[c-1-i]
			Signals.emit_signal("MiniCoinAnimation",(c-1)-i)
			Signals.emit_signal("CoinScored")
			Signals.emit_signal("PopupMessage", str("+",Globals.CoinValues[c-1-i],"!"),pos,new_pos,colorToUse)
	else: 
		var collective = 0
		for i in runCount:
			Signals.emit_signal("MiniCoinAnimation",(c-1)-i)
			collective += Globals.CoinValues[c-1-i]
			
		var scoreToAdd = runCount * collective
		Globals.currentScore += scoreToAdd
		var middleOfArray = c - (runArray.size()-(runArray.size()/2))
		Signals.emit_signal("ComboScored")
		var pos : Vector2 = Vector2(Globals.CoinHistorySprites[middleOfArray].global_position.x,Globals.CoinHistorySprites[middleOfArray].global_position.y-10)
		var new_pos : Vector2 = Vector2(pos.x, pos.y-30)
		Signals.emit_signal("PopupMessage",(str("Run! +",scoreToAdd,"!")), pos,new_pos, colorToUse)
