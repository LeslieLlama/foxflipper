extends Control

var rng = RandomNumberGenerator.new()

var reflipCount = 3
var maxReflipCount = 3

var currentScore = 0

var RoundNumber = 1
var RequiredScore = [150,300,600,1200,2400,4800,9600,12000,14000,19200,28000]

var purchases = 0
var maxPurchases = 2

enum GameState {MENU,BETTING,SCORING,SHOP,GAME_OVER}
var CurrentGameState = GameState.MENU

var coinTween

var colorRed = Color("D0665A")
var colorBlue = Color("65A7C1")
var title_position : Vector2

var highest_score : int

@onready var CoinHistoryNode = $CoinFlipHistory
@onready var NextCoinButton = $NextCoinButton
@onready var ReDoCoinButton = $ReDoCoinButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 3:
		_add_coin()
	$RequiredScoreLabel.text = str(RequiredScore[0])
	title_position = $Title.position
	$Title.position = Vector2(title_position.x,title_position.y-160)
	$ReDoCoinButton.disabled = true
	_title_animation(true)

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_UP):
		_title_animation(false)
	if Input.is_key_pressed(KEY_DOWN):
		_title_animation(true)

func _on_next_coin_button_button_up() -> void:
	print(CurrentGameState)
	if CurrentGameState == GameState.MENU:
		_title_animation(false)
		CurrentGameState = GameState.BETTING
	if CurrentGameState == GameState.SHOP:
		reset_table()
		CurrentGameState = GameState.BETTING
		return
	if CurrentGameState == GameState.BETTING:
		if Globals.coinCount == Globals.maxCoinCount:
			CurrentGameState = GameState.SCORING
			coin_pattern_searcher()
			ReDoCoinButton.disabled = true
			NextCoinButton.text = "Shop"
			return
		flip_coin(false)
	if CurrentGameState == GameState.SCORING:
		$ShopPanel.show()
		CurrentGameState = GameState.SHOP
		NextCoinButton.text = "Next Round"
	if CurrentGameState == GameState.GAME_OVER:
		reset_game()
		_title_animation(true)
		
func _title_animation(show : bool):
	if show == false: #hide
		var tween = get_tree().create_tween().bind_node(self)
		tween.tween_property($Title, "position", Vector2(title_position.x,title_position.y-160), 1).set_trans(Tween.TRANS_QUINT)
		$Credits.hide()
	else: 
		var tween = get_tree().create_tween().bind_node(self)
		tween.tween_property($Title, "position", Vector2(title_position.x,title_position.y), 1).set_trans(Tween.TRANS_QUINT)
		$Credits.show()
		
func _coin_flip_animation(heads : bool):
	if coinTween:
		if coinTween.is_running() == true:
			Signals.emit_signal("CoinHistoryDisplayUpdate")
		coinTween.kill()
		 #if the player mashes the flip button, update the history vissually. and kill/restart the tween. 
	coinTween = get_tree().create_tween().bind_node(self)
	if heads == true:
		coinTween.tween_property($CoinTailsSide, "scale", Vector2(1,0), 0.1).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property($CoinHeadsSide, "scale", Vector2(1,1), 0.1).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property($CoinHeadsSide, "scale", Vector2(1,0), 0.1).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property($CoinTailsSide, "scale", Vector2(1,1), 0.1).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property($CoinTailsSide, "scale", Vector2(1,0), 0.2).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property($CoinHeadsSide, "scale", Vector2(1,1), 0.2).set_trans(Tween.TRANS_QUINT)
	else: 
		coinTween.tween_property($CoinTailsSide, "scale", Vector2(1,0), 0.1).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property($CoinHeadsSide, "scale", Vector2(1,1), 0.1).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property($CoinHeadsSide, "scale", Vector2(1,0), 0.1).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property($CoinTailsSide, "scale", Vector2(1,1), 0.1).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property($CoinHeadsSide, "scale", Vector2(1,0), 0.2).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property($CoinTailsSide, "scale", Vector2(1,1), 0.2).set_trans(Tween.TRANS_QUINT)
	Signals.emit_signal("CoinHistoryDisplayUpdate")
	
func _on_re_do_coin_button_button_up() -> void:
	if reflipCount >= 1:
		flip_coin(true)
		
func flip_coin(is_reflip : bool):
	if is_reflip == true && reflipCount > 0:
		Globals.CoinHistory.pop_back()
		reflipCount -= 1
		Globals.coinCount -= 1
	
	var flip_value = rng.randi_range(0, 1)
	if flip_value == 1:
		_coin_flip_animation(true)
		Globals.CoinHistory.append(1)
		Globals.coinCount += 1
	else: 
		_coin_flip_animation(false)
		Globals.CoinHistory.append(0)
		Globals.coinCount += 1
	if reflipCount == 0:
		ReDoCoinButton.disabled = true
	if Globals.coinCount == 1:
		ReDoCoinButton.disabled = false
	#update the UI
	$ReDoCoinButton/ReflipAmmount.text = str(reflipCount,"x")
	$NextCoinButton/CoinAmmount.text = str(Globals.coinCount,"/",Globals.maxCoinCount)
	print(Globals.CoinHistory)
	if Globals.coinCount == Globals.maxCoinCount: $NextCoinButton.text = "Score Coins"
	Signals.emit_signal("FlipCoin", Globals.coinCount)

#COIN HISTORY UPDATE WENT HERE

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
			print("last coin")
			if Globals.CoinHistory[c] == 0: #tails
				pattern_payoff(runCount, runArray,c+1, Globals.tailsValue, colorBlue)
			else: #heads
				pattern_payoff(runCount, runArray,c+1, Globals.headsValue, colorRed)
			runCount = 1
			runArray.clear()
	check_round_won()
	
func pattern_payoff(runCount : int, runArray, c : int, coinValue : int, colorToUse : Color):
	for a in runArray:
		Signals.emit_signal("MiniCoinTriggerAnimation",(c-1))
	if runCount < 3:
		#print(str("runcount > 2 : ",runCount))
		#print(str("runarray = ",runArray))
		for i in runCount:
			currentScore += coinValue
			#print(str("i == ",i,"coin == ",c))
			#pop_up_message(str("+",coinValue,"!"), CoinHistorySprites[(c-1)].global_position, colorToUse)
	else: 
		#print(str("runcount > 2 : ",runCount))
		#print(str("runarray = ",runArray))
		var scoreToAdd = ((runCount) * coinValue) * (runCount)
		currentScore += scoreToAdd
		var middleOfArray = c - (runArray.size()/2)
		#pop_up_message(str("Run! +",scoreToAdd,"!"), CoinHistorySprites[middleOfArray].global_position, colorToUse)
		
	
func pop_up_message(textToSay : String, pos : Vector2, textColour : Color):
	print(str("pop up message at", pos))
	var message = Label.new()
	message.text = textToSay
	message.position = Vector2(pos.x,pos.y-10)
	message.modulate = textColour
	add_child(message)
	var tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(message, "position", Vector2(pos.x,pos.y-20), 1).set_trans(tween.TRANS_QUAD)
	tween.tween_callback(message.queue_free)
	
	
func check_round_won():
	if currentScore >= RequiredScore[RoundNumber-1]:
		RoundNumber += 1
		pop_up_message(str("Round Cleared!"),Vector2(660,120) , colorRed)
		pop_up_message(str("Well Done"),Vector2(660,140) , colorBlue)
	else: 
		print("Game Over!")
		game_over()
	if currentScore >= highest_score : highest_score = currentScore
	$RoundScoreLabel.text = str(currentScore,"/")
	if CurrentGameState != GameState.GAME_OVER && RoundNumber == 7:
		game_won()
	
func game_over():
	$GameOverPanel.show()
	CurrentGameState = GameState.GAME_OVER
	NextCoinButton.text = "Play Again?"
	
func game_won():
	$GameWonPanel.show()
	CurrentGameState = GameState.GAME_OVER
	$GameWonPanel/RetryButton.text = str("Thank You for Playing\nHighest Score : ",highest_score)
	NextCoinButton.text = "Menu"
	
func _on_retry_button_button_up() -> void:
	reset_game()
	
func reset_game():
	Signals.emit_signal("ResetGame")
	RoundNumber = 1
	maxReflipCount = 3
	Globals.maxCoinCount = 0
	for c in CoinHistoryNode.get_children():
		c.queue_free()
	await get_tree().create_timer(0.01).timeout #this is so dumb but if you don't stall it slightly both loops happen concurrently and it screws them up
	for i in 3:
		_add_coin()
	Globals.totalValue = 100
	$GameOverPanel.hide()
	$GameWonPanel.hide()
	Globals.headsValue = 50
	Globals.tailsValue = 50
	Globals.totalValue = 100
	highest_score = 0
	reset_table()
	
func reset_table():
	Signals.emit_signal("ResetTable")
	currentScore = 0
	Globals.CoinHistory.clear()
	Globals.coinCount = 0
	reflipCount = maxReflipCount
	$CurrentRoundLabel.text = str("Round","\n",RoundNumber,"/6")
	$RequiredScoreLabel.text = str(RequiredScore[RoundNumber-1])
	$RoundScoreLabel.text = str(currentScore,"/")
	$ReDoCoinButton/ReflipAmmount.text = str(reflipCount,"x")
	ReDoCoinButton.disabled = true
	$NextCoinButton/CoinAmmount.text = str(Globals.coinCount,"/",Globals.maxCoinCount)
	$NextCoinButton.text = "Flip"
	$ShopPanel.hide()
	purchases = 0
	$ShopPanel/PurchaseCount.text = str("Purchases: ",purchases,"/",maxPurchases)
	disable_buy_buttons(false)
	CurrentGameState = GameState.MENU
	
func _add_coin():
	Signals.emit_signal("PurchaseCoin")

func _add_reflips():
	maxReflipCount += 1
	$ReDoCoinButton/ReflipAmmount.text = str("x",maxReflipCount)
	
func _add_points():
	Signals.emit_signal("PurchasePoints")

func add_purchase():
	purchases += 1
	$ShopPanel/PurchaseCount.text = str("Purchases: ",purchases,"/",maxPurchases)
	if purchases == maxPurchases:
		disable_buy_buttons(true)
func disable_buy_buttons(disable_value : bool):
	$ShopPanel/BuyPointsPanel/Button.disabled = disable_value
	$ShopPanel/BuyCoinsPanel/Button.disabled = disable_value
	$ShopPanel/BuyReflips/Button.disabled = disable_value
	
func _on_HelpButton_toggled(toggled_on: bool) -> void:
	if toggled_on == true: #show
		var tween = get_tree().create_tween().bind_node(self)
		tween.tween_property($ExplanationPanel, "position", Vector2(0,29), 1).set_trans(Tween.TRANS_QUINT)
		$ExplanationPanel/Button.text = "<"
	else: #hide
		var tween = get_tree().create_tween().bind_node(self)
		tween.tween_property($ExplanationPanel, "position", Vector2(-303,29), 1).set_trans(Tween.TRANS_QUINT)
		$ExplanationPanel/Button.text = "?"
