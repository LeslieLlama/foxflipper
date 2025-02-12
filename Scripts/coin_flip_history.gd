extends GridContainer

@export var emptyCoinSprite : Texture2D
@export var canceledCoinSprite : Texture2D
@export var headsCoinSprite : Texture2D
@export var tailsCoinSprite : Texture2D

@export var item1 : LuckyCharm
@export var item2 : LuckyCharm

var colorRed = Color("D0665A")
var colorBlue = Color("65A7C1")

var CoinValues = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.CoinHistoryDisplayUpdate.connect(coin_history_display_update)
	Signals.PurchaseCoin.connect(_add_coin)
	Signals.ResetGame.connect(_reset_game)
	Signals.ResetTable.connect(_reset_table)
	Signals.MiniCoinAnimation.connect(mini_coin_trigger_animation)
	#Signals.ScoreCoins.connect(scoring_sequence)
	
func coin_history_display_update():
	for c in Globals.CoinHistory:
		if c == 1:
			Globals.CoinHistorySprites[Globals.coinCount-1].texture = headsCoinSprite
		else:
			Globals.CoinHistorySprites[Globals.coinCount-1].texture = tailsCoinSprite
		if Globals.coinsToThrow + Globals.coinCount != Globals.maxCoinCount:
			Globals.CoinHistorySprites[Globals.coinsToThrow + Globals.coinCount].texture = canceledCoinSprite
	mini_coin_trigger_animation(Globals.coinCount-1)

func mini_coin_trigger_animation(c : int):
	var tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(Globals.CoinHistorySprites[c], "scale", Vector2(1.1,1.1), 0.1).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(Globals.CoinHistorySprites[c], "scale", Vector2(1,1), 0.1).set_trans(Tween.TRANS_BOUNCE)
	
#func scoring_sequence():
	#CoinValues = await add_wager_to_coins()
	#if item1 != null:
		#CoinValues = await item1.AddToScore(CoinValues)
	#if item2 != null:
		#CoinValues = await item2.AddToScore(CoinValues)
	#coin_pattern_searcher()
	#
#func add_wager_to_coins():
	#CoinValues.clear()
	#for c in Globals.CoinHistory.size():
		#await get_tree().create_timer(0.1).timeout
		#var negative_c = (Globals.CoinHistory.size()-1) - c
		#var pos : Vector2 = Vector2(Globals.CoinHistorySprites[(negative_c)].global_position.x,Globals.CoinHistorySprites[(negative_c)].global_position.y+40)
		#var new_pos : Vector2 = Vector2(pos.x, pos.y+50)
		#if Globals.CoinHistory[negative_c] == 0: #tails
			#CoinValues.append(Globals.tailsValue)
			#Signals.emit_signal("PopupMessage", str(CoinValues[c]),pos,new_pos,colorBlue)
		#else: #heads
			#CoinValues.append(Globals.headsValue)
			#Signals.emit_signal("PopupMessage", str(CoinValues[c]),pos,new_pos,colorRed)
		#mini_coin_trigger_animation(negative_c)
		#Signals.emit_signal("AddPointsToCoin")
	#await get_tree().create_timer(0.3).timeout
	#return CoinValues
#
#func coin_pattern_searcher():
	#var runCount = 0
	#var previousCoinValue = -1
	#var highestRunCount = 1
	#var runArray = []
	#
	#for c in Globals.CoinHistory.size():
		#await get_tree().create_timer(0.1).timeout
		#if Globals.CoinHistory[c] == previousCoinValue || c==0:
			#runCount += 1
			#runArray.append(Globals.CoinHistory[c])
		#else: 
			##run is broken
			#if Globals.CoinHistory[c-1] == 0: #tails
				#pattern_payoff(runCount, runArray,c,colorBlue)
			#else: #heads
				#pattern_payoff(runCount, runArray,c,colorRed)
			#runCount = 1
			#runArray.clear()
			#runArray.append(Globals.CoinHistory[c])
		#previousCoinValue = Globals.CoinHistory[c]
		#if c+1 == Globals.CoinHistory.size():
			#await get_tree().create_timer(0.1).timeout
			#print("last coin")
			#if Globals.CoinHistory[c] == 0: #tails
				#pattern_payoff(runCount, runArray,c+1, colorBlue)
			#else: #heads
				#pattern_payoff(runCount, runArray,c+1,colorRed)
			#runCount = 1
			#runArray.clear()
	#Signals.emit_signal("AllCoinsScored")
	#print(str("Coin Values : ",CoinValues))
	#
#func pattern_payoff(runCount : int, runArray, c : int, colorToUse : Color):
	#for a in runArray:
		#pass
	#if runCount < 3:
		#for i in runCount:
			#var pos : Vector2 = Vector2(Globals.CoinHistorySprites[(c-1-i)].global_position.x,Globals.CoinHistorySprites[(c-1-i)].global_position.y-10)
			#var new_pos : Vector2 = Vector2(pos.x, pos.y-30)
			#Globals.currentScore += CoinValues[c-1-i]
			#mini_coin_trigger_animation((c-1)-i)
			#Signals.emit_signal("CoinScored")
			#Signals.emit_signal("PopupMessage", str("+",CoinValues[c-1-i],"!"),pos,new_pos,colorToUse)
	#else: 
		#var collective = 0
		#for i in runCount:
			#mini_coin_trigger_animation((c-1)-i)
			#collective += CoinValues[c-1-i]
		##var scoreToAdd = ((runCount) * coinValue) * (runCount)
		#
		#var scoreToAdd = runCount * collective
		#Globals.currentScore += scoreToAdd
		#var middleOfArray = c - (runArray.size()-(runArray.size()/2))
		#Signals.emit_signal("ComboScored")
		#var pos : Vector2 = Vector2(Globals.CoinHistorySprites[middleOfArray].global_position.x,Globals.CoinHistorySprites[middleOfArray].global_position.y-10)
		#var new_pos : Vector2 = Vector2(pos.x, pos.y-30)
		#Signals.emit_signal("PopupMessage",(str("Run! +",scoreToAdd,"!")), pos,new_pos, colorToUse)
	
func _reset_game():
	for c in self.get_children():
		c.queue_free()
	Globals.CoinHistorySprites.clear()
	
func _reset_table():
	for c in Globals.CoinHistorySprites:
		c.texture = emptyCoinSprite
		
func _add_coin():
	Globals.maxCoinCount += 1
	Globals.coinsToThrow += 1
	#var child_node = ColorRect.new()
	var child_node = TextureRect.new()
	child_node.texture = emptyCoinSprite
	child_node.custom_minimum_size = Vector2(75,75)
	child_node.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	child_node.stretch_mode = TextureRect.STRETCH_SCALE
	self.add_child(child_node)
	Globals.CoinHistorySprites = self.get_children()
	mini_coin_trigger_animation(Globals.maxCoinCount-1)
	
