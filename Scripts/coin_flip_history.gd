extends GridContainer

@export var emptyCoinSprite : Texture2D
@export var headsCoinSprite : Texture2D
@export var tailsCoinSprite : Texture2D

var colorRed = Color("D0665A")
var colorBlue = Color("65A7C1")

var CoinHistorySprites = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.CoinHistoryDisplayUpdate.connect(coin_history_display_update)
	Signals.PurchaseCoin.connect(_add_coin)
	Signals.ResetGame.connect(_reset_game)
	Signals.ResetTable.connect(_reset_table)
	Signals.ScoreCoins.connect(coin_pattern_searcher)


func coin_history_display_update():
	for c in Globals.CoinHistory:
		if c == 1:
			CoinHistorySprites[Globals.coinCount-1].texture = headsCoinSprite
		else:
			CoinHistorySprites[Globals.coinCount-1].texture = tailsCoinSprite
	mini_coin_trigger_animation(Globals.coinCount-1)

func mini_coin_trigger_animation(c : int):
	var tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(CoinHistorySprites[c], "scale", Vector2(1.1,1.1), 0.1).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(CoinHistorySprites[c], "scale", Vector2(1,1), 0.1).set_trans(Tween.TRANS_BOUNCE)
	
func coin_pattern_searcher():
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
				pattern_payoff(runCount, runArray,c, Globals.tailsValue, colorBlue)
			else: #heads
				pattern_payoff(runCount, runArray,c, Globals.headsValue, colorRed)
			runCount = 1
			runArray.clear()
			runArray.append(Globals.CoinHistory[c])
		previousCoinValue = Globals.CoinHistory[c]
		if c+1 == Globals.CoinHistory.size():
			await get_tree().create_timer(0.1).timeout
			print("last coin")
			if Globals.CoinHistory[c] == 0: #tails
				pattern_payoff(runCount, runArray,c+1, Globals.tailsValue, colorBlue)
			else: #heads
				pattern_payoff(runCount, runArray,c+1, Globals.headsValue, colorRed)
			runCount = 1
			runArray.clear()
	Signals.emit_signal("AllCoinsScored")
	
func pattern_payoff(runCount : int, runArray, c : int, coinValue : int, colorToUse : Color):
	for a in runArray:
		pass
	if runCount < 3:
		for i in runCount:
			Globals.currentScore += coinValue
			mini_coin_trigger_animation((c-1)-i)
			Signals.emit_signal("CoinScored")
			Signals.emit_signal("PopupMessage", str("+",coinValue,"!"),CoinHistorySprites[(c-1-i)].global_position,colorToUse)
	else: 
		for i in runCount:
			mini_coin_trigger_animation((c-1)-i)
		var scoreToAdd = ((runCount) * coinValue) * (runCount)
		Globals.currentScore += scoreToAdd
		var middleOfArray = c - (runArray.size()-(runArray.size()/2))
		Signals.emit_signal("PopupMessage",(str("Run! +",scoreToAdd,"!")), CoinHistorySprites[middleOfArray].global_position, colorToUse)
	
func _reset_game():
	CoinHistorySprites.clear()
	
func _reset_table():
	for c in CoinHistorySprites:
		c.texture = emptyCoinSprite
		
func _add_coin():
	Globals.maxCoinCount += 1
	#var child_node = ColorRect.new()
	var child_node = TextureRect.new()
	child_node.texture = emptyCoinSprite
	child_node.custom_minimum_size = Vector2(50,50)
	child_node.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	child_node.stretch_mode = TextureRect.STRETCH_SCALE
	self.add_child(child_node)
	CoinHistorySprites = self.get_children()
	mini_coin_trigger_animation(Globals.maxCoinCount-1)
