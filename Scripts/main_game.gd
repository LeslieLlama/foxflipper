extends Control

var rng = RandomNumberGenerator.new()

var reflipCount = 3
var maxReflipCount = 3

var RoundNumber = 1
var RequiredScore = [150,300,600,1200,2400,4800,9600,12000,14000,19200,28000]

var purchases = 0
var maxPurchases = 2

enum GameState {MENU,BETTING,SCORING,SHOP,GAME_OVER}
var CurrentGameState = GameState.MENU

var coinTween


var colorRed = Color("D0665A")
var colorBlue = Color("65A7C1")

var highest_score : int

@export var CoinHistoryNode : GridContainer
@export var NextCoinButton : Button
@export var ReDoCoinButton : Button
@export var CoinAmmount : Label
@export var ReflipAmmount : Label
@export var CoinTailsSide : TextureRect
@export var CoinHeadsSide : TextureRect
@export var Title : Control
@export var TitleAnchor : Control
@export var CurrentRoundLabel : Label
@export var ShopPanel : Panel 
@export var ShopAnchor : Control
@export var RoundScoreLabel : Label
@export var RequiredScoreLabel : Label
@export var SpeechBubble : TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.PopupMessage.connect(pop_up_message)
	Signals.AllCoinsScored.connect(check_round_won)
	for i in 4:
		_add_coin()
	RequiredScoreLabel.text = str(RequiredScore[0])
	_reset_node_positions()
	ReDoCoinButton.disabled = true
	get_tree().get_root().size_changed.connect(resize)
	
	var size = get_viewport_rect().size
	var top = size.y + TitleAnchor.position.y
	Title.position = Vector2(TitleAnchor.position.x,-top)
	await get_tree().create_timer(0.1).timeout
	_title_animation(true)
	
	
func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		game_won()
	
func _reset_node_positions():
	var title_position = TitleAnchor.position
	Title.position = Vector2(title_position.x,title_position.y-160)
	#bandaid solution to hide shop at start of game
	_shop_animation(false)
	await get_tree().create_timer(1).timeout
	_shop_animation(false)

func resize():
	var size = get_viewport_rect().size
	if size.x > (size.y-400):
		$LayoutBox.vertical = false
		$LayoutBox/Left/HistoryZone.vertical = true
		#$LayoutBox/Right/ShopStuffs/ShopPanel/VBoxContainer.vertical = true
	else: 
		$LayoutBox.vertical = true
		$LayoutBox/Left/HistoryZone.vertical = false
		#$LayoutBox/Right/ShopStuffs/ShopPanel/VBoxContainer.vertical = false
	if CurrentGameState != GameState.SHOP:
		ShopPanel.position = Vector2(ShopAnchor.position.x+ShopPanel.size.x,0)

func _on_next_coin_button_button_up() -> void:
	SpeechBubble.hide()
	if CurrentGameState == GameState.MENU:
		_title_animation(false)
		CurrentGameState = GameState.BETTING
	if CurrentGameState == GameState.SHOP:
		reset_table()
		Signals.emit_signal("NextRound")
		CurrentGameState = GameState.BETTING
		return
	if CurrentGameState == GameState.BETTING:
		#if Globals.coinCount == Globals.maxCoinCount:
		if Globals.coinsToThrow <= 0:
			CurrentGameState = GameState.SCORING
			Signals.emit_signal("ScoreCoins")
			ReDoCoinButton.disabled = true
			NextCoinButton.text = "Shop"
			return
		flip_coin(false)
	if CurrentGameState == GameState.SCORING:
		_shop_animation(true)
		CurrentGameState = GameState.SHOP
		NextCoinButton.text = "Next Round"
	if CurrentGameState == GameState.GAME_OVER:
		reset_game()
		_title_animation(true)
		
func _shop_animation(show : bool):
	if show == true:
		_set_shop_visible(true)
		_generic_move_tween(ShopPanel,ShopAnchor.position)
	else:
		var tween = get_tree().create_tween().bind_node(self)
		tween.tween_property(ShopPanel, "position", Vector2(ShopAnchor.position.x+ShopPanel.size.x,0), 1).set_trans(Tween.TRANS_QUINT)
		tween.tween_callback(_set_shop_visible.bind(false))
		
func _set_shop_visible(is_visible : bool): 
	if is_visible : ShopPanel.visible = true
	else: ShopPanel.visible = false
	
func _title_animation(show : bool):
	if show == false: #hide
		var size = get_viewport_rect().size
		var top = size.y + TitleAnchor.position.y
		_generic_move_tween(Title,Vector2(TitleAnchor.position.x,-top))
		$LayoutBox/Right/Credits.hide()
	else: 
		_generic_move_tween(Title,TitleAnchor.position)
		$LayoutBox/Right/Credits.show()
		
func _on_HelpButton_toggled(toggled_on: bool) -> void:
	if toggled_on == true: #show
		_generic_move_tween($ExplanationPanel,Vector2(0,29))
		$ExplanationPanel/Button.text = "<"
	else: #hide
		_generic_move_tween($ExplanationPanel,Vector2(-303,29))
		$ExplanationPanel/Button.text = "?"
		
func _generic_move_tween(nodeToMove : Control, whereToMove : Vector2):
	var tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(nodeToMove, "position", whereToMove, 1).set_trans(Tween.TRANS_QUINT)
		
func _coin_flip_animation(heads : bool):
	if coinTween:
		if coinTween.is_running() == true: #if the player mashes the flip button, update the history vissually. and kill/restart the tween. 
			_update_coin_history()
		coinTween.kill()
	coinTween = get_tree().create_tween().bind_node(self)
	if heads == true:
		coinTween.tween_property(CoinTailsSide, "scale", Vector2(0.8,0), 0.1).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property(CoinHeadsSide, "scale", Vector2(0.8,0.8), 0.1).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property(CoinHeadsSide, "scale", Vector2(0.8,0), 0.1).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property(CoinTailsSide, "scale", Vector2(0.8,0.8), 0.1).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property(CoinTailsSide, "scale", Vector2(0.8,0), 0.2).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property(CoinHeadsSide, "scale", Vector2(0.8,0.8), 0.2).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_callback(_update_coin_history)
	else: 
		coinTween.tween_property(CoinTailsSide, "scale", Vector2(0.8,0), 0.1).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property(CoinHeadsSide, "scale", Vector2(0.8,0.8), 0.1).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property(CoinHeadsSide, "scale", Vector2(0.8,0), 0.1).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property(CoinTailsSide, "scale", Vector2(0.8,0.8), 0.1).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property(CoinHeadsSide, "scale", Vector2(0.8,0), 0.2).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_property(CoinTailsSide, "scale", Vector2(0.8,0.8), 0.2).set_trans(Tween.TRANS_QUINT)
		coinTween.tween_callback(_update_coin_history)
		
func _update_coin_history():
	Signals.emit_signal("CoinHistoryDisplayUpdate")
	
func _on_re_do_coin_button_button_up() -> void:
	flip_coin(true)
	#if reflipCount >= 1:
		#flip_coin(true)
		
func flip_coin(is_reflip : bool):
	Globals.coinsToThrow -= 1
	$LayoutBox/Center/LargeCoinZone/CoinCount.text = str("Coins:\nx",Globals.coinsToThrow)
	#if is_reflip == true && reflipCount > 0:
	if is_reflip == true:
		Globals.CoinHistory.pop_back()
		reflipCount -= 1
		Globals.coinCount -= 1
	
	var flip_value = rng.randf_range(0, 1)
	print(str("flip value : ",flip_value))
	if flip_value <= Globals.headsThreshhold:
		_coin_flip_animation(false)
		Globals.CoinHistory.append(0)
		Globals.coinCount += 1
	else: 
		_coin_flip_animation(true)
		Globals.CoinHistory.append(1)
		Globals.coinCount += 1
	#if reflipCount == 0:
		#ReDoCoinButton.disabled = true
	if Globals.coinCount == 1:
		ReDoCoinButton.disabled = false
	#update the UI
	ReflipAmmount.text = str(reflipCount,"x")
	CoinAmmount.text = str(Globals.coinCount,"/",Globals.maxCoinCount)
	print(Globals.CoinHistory)
	#if Globals.coinCount == Globals.maxCoinCount: NextCoinButton.text = "Score Coins"
	if Globals.coinsToThrow <= 0:
		NextCoinButton.text = "Score Coins"
		ReDoCoinButton.disabled = true
	Signals.emit_signal("FlipCoin", Globals.coinCount)


func pop_up_message(textToSay : String, pos : Vector2, textColour : Color):
	print(str("pop up message at", pos))
	var message = Label.new()
	message.text = textToSay
	message.position = Vector2(pos.x,pos.y-20)
	message.modulate = textColour
	message.add_theme_font_size_override("font_size", 34)
	add_child(message)
	var tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(message, "position", Vector2(pos.x,pos.y-40), 1).set_trans(tween.TRANS_QUAD)
	tween.tween_callback(message.queue_free)
	
func _create_speech_bubble(textToSay : String):
	SpeechBubble.show()
	var txt = SpeechBubble.get_child(0)
	txt.text = textToSay
	
	
func check_round_won():
	if Globals.currentScore >= RequiredScore[RoundNumber-1]:
		RoundNumber += 1
		#pop_up_message(str("Round Cleared!"),Vector2(660,120) , colorRed)
		#pop_up_message(str("Well Done"),Vector2(660,140) , colorBlue)
		_create_speech_bubble("Round Cleared!\nWell Done")
	else: 
		print("Game Over!")
		game_over()
	if Globals.currentScore >= highest_score : highest_score = Globals.currentScore
	RoundScoreLabel.text = str(Globals.currentScore,"/")
	if CurrentGameState != GameState.GAME_OVER && RoundNumber == 7:
		game_won()
	
func game_over():
	#$GameOverPanel.show()
	_create_speech_bubble("Game Over!~")
	CurrentGameState = GameState.GAME_OVER
	NextCoinButton.text = "Play Again?"
	
func game_won():
	$GameWonPanel.show()
	_create_speech_bubble("You Win!!")
	CurrentGameState = GameState.GAME_OVER
	$GameWonPanel/Title.text = str("Thank You for Playing\nHighest Score : ",highest_score)
	NextCoinButton.text = "Menu"
	
func _on_retry_button_button_up() -> void:
	reset_game()
	
func reset_game():
	Signals.emit_signal("ResetGame")
	RoundNumber = 1
	maxReflipCount = 3
	Globals.headsThreshhold = 0.5
	Globals.maxCoinCount = 0
	Globals.coinsToThrow = 0
	for c in CoinHistoryNode.get_children():
		c.queue_free()
	await get_tree().create_timer(0.01).timeout #this is so dumb but if you don't stall it slightly both loops happen concurrently and it screws them up
	for i in 4:
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
	Globals.currentScore = 0
	Globals.CoinHistory.clear()
	Globals.coinCount = 0
	Globals.coinsToThrow = Globals.maxCoinCount
	reflipCount = maxReflipCount
	CurrentRoundLabel.text = str("Round","\n",RoundNumber,"/6")
	RequiredScoreLabel.text = str(RequiredScore[RoundNumber-1])
	RoundScoreLabel.text = str(Globals.currentScore,"/")
	ReflipAmmount.text = str(reflipCount,"x")
	ReDoCoinButton.disabled = true
	CoinAmmount.text = str(Globals.coinCount,"/",Globals.maxCoinCount)
	NextCoinButton.text = "Flip"
	_shop_animation(false)
	purchases = 0
	$LayoutBox/Right/ShopStuffs/ShopPanel/PurchaseCount.text = str("Purchases: ",purchases,"/",maxPurchases)
	disable_buy_buttons(false)
	CurrentGameState = GameState.MENU
	
func _add_coin():
	Signals.emit_signal("PurchaseCoin")

func _add_reflips():
	maxReflipCount += 1
	ReflipAmmount.text = str("x",maxReflipCount)
	
func _add_weight():
	Signals.emit_signal("PurchaseWeight")
	
func _add_points():
	Signals.emit_signal("PurchasePoints")

func add_purchase():
	purchases += 1
	$LayoutBox/Right/ShopStuffs/ShopPanel/PurchaseCount.text = str("Purchases: ",purchases,"/",maxPurchases)
	if purchases == maxPurchases:
		disable_buy_buttons(true)
func disable_buy_buttons(disable_value : bool):
	$LayoutBox/Right/ShopStuffs/ShopPanel/VBoxContainer/BuyPointsPanel/Button.disabled = disable_value
	$LayoutBox/Right/ShopStuffs/ShopPanel/VBoxContainer/BuyCoinsPanel/Button.disabled = disable_value
	$LayoutBox/Right/ShopStuffs/ShopPanel/VBoxContainer/BuyWeight/Button.disabled = disable_value
	
