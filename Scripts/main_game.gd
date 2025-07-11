extends Control

var rng = RandomNumberGenerator.new()

var reflipCount = 3
var maxReflipCount = 3

var RoundNumber = 1
var RequiredScore = [150,300,600,1200,2400,4800,9600,12000,14000,19200,28000]

enum GameState {MENU,BETTING,SCORING,SHOP,GAME_OVER}
var CurrentGameState = GameState.MENU

var coinTween

var coinFullSize : Vector2 = Vector2(0.7,0.7)
var coinFlatSize : Vector2 = Vector2(0.7,0)

var colorRed = Color("D0665A")
var colorBlue = Color("65A7C1")
var colorWhite = Color("dcdccc")
var colorBlack = Color("5b141c")
var colorPalette = [colorWhite, colorBlue, colorRed, colorBlack]
var currentColorTie = 0
var highest_score : int

@export var NextCoinButton : Button
@export var ReDoCoinButton : Button
@export var CoinAmmount : Label
@export var ReflipAmmount : Label
@export var Title : Control
@export var TitleAnchor : Control
@export var CurrentRoundLabel : Label
@export var ShopPanel : Panel 
@export var ShopAnchor : Control
@export var RoundScoreLabel : RichTextLabel
@export var SpeechBubble : Control
@export var credits : Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.PopupMessage.connect(pop_up_message)
	Signals.Mouse_Over_Shop.connect(_item_speech_bubble)
	Signals.Mouse_End_Shop.connect(_close_speech_bubble)
	Signals.AllCoinsScored.connect(check_round_won)
	Signals.Mouse_Over.connect(_item_speech_bubble)
	Signals.Mouse_End.connect(_close_speech_bubble)
	Signals.FlipCoin.connect(_flip_coin)
	Signals.UpdateScoreUI.connect(_update_score_requirement_ui)
	Signals.ScoreCoins.connect(_coins_scoring)
	for i in 4:
		Signals.emit_signal("PurchaseCoin")
	Globals.currentScoreRequirement = RequiredScore[0]
	Globals.score_position = $Layoutbox/Top/DealerZone/AdjacentUI/RoundScoreLabel.global_position
	_update_score_requirement_ui()
	_reset_node_positions()
	ReDoCoinButton.disabled = true
	get_tree().get_root().size_changed.connect(resize)
	
	var ensize = get_viewport_rect().size
	var top = ensize.y + TitleAnchor.position.y
	Title.position = Vector2(TitleAnchor.position.x,-top)
	await get_tree().create_timer(0.1).timeout
	_title_animation(true)
	
func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		pass #testing function
	$StateIndicator.text = str(CurrentGameState)
	
func _tool_tip_on(iname, desc):
	$Tooltip.position = _tool_tip_position()
	$Tooltip.show()
	$Tooltip/VBoxContainer/itemName.text = iname
	$Tooltip/VBoxContainer/itemDescription.text = desc
	
func _tool_tip_off():
	$Tooltip.hide()
	
func _update_score_requirement_ui():
	RoundScoreLabel.text = str(Globals.currentScore,"/","[color=#65A7C1]",Globals.currentScoreRequirement,"[/color]")
	
func _tool_tip_position():
	var cursor_pos = get_viewport().get_mouse_position()
	var screensize = get_viewport_rect().size
	var rect_size = $Tooltip.size
	var adj_pos : Vector2
	adj_pos.x = clamp(cursor_pos.x, 0, screensize.x - rect_size.x - 4)
	adj_pos.y = clamp(cursor_pos.y, 0 , screensize.y - rect_size.y - 4)
	return adj_pos
	
func _reset_node_positions():
	var title_position = TitleAnchor.position
	Title.position = Vector2(title_position.x,title_position.y-160)
	#bandaid solution to hide shop at start of game
	_shop_animation(false)
	await get_tree().create_timer(1).timeout
	_shop_animation(false)

func resize():
	var ensize = get_viewport_rect().size
	if ensize.x > (ensize.y-400): #horizontal 
		$Layoutbox/Bottom.vertical = false
		$Layoutbox/Bottom/Left/HistoryZone.vertical = true
		#$LayoutBox/Left/SpacerPanel.show()
		$Layoutbox/Bottom/Left.size_flags_stretch_ratio = 1
		$Layoutbox/Bottom/Center.size_flags_stretch_ratio = 2.5
		$Layoutbox/Bottom/Left/HistoryZone.move_child($Layoutbox/Bottom/Left/HistoryZone/ScoreCalculation, 0)
	else: #Vertical
		$Layoutbox/Bottom.vertical = true 
		$Layoutbox/Bottom/Center.size_flags_stretch_ratio = 1.5
		$Layoutbox/Bottom/Left/HistoryZone.vertical = false
		#$LayoutBox/Left/SpacerPanel.hide()
		$Layoutbox/Bottom/Left.size_flags_stretch_ratio = 0.6
		$Layoutbox/Bottom/Left/HistoryZone.move_child($Layoutbox/Bottom/Left/HistoryZone/ScoreCalculation, 1)

	if CurrentGameState != GameState.SHOP:
		ShopPanel.position = Vector2(ShopAnchor.position.x+ShopPanel.size.x,0)

func _coins_scoring():
	NextCoinButton.disabled = true

func _on_next_coin_button_button_up() -> void:
	##should probably change this to a match statement
	_close_speech_bubble()
	if CurrentGameState == GameState.MENU:
		_title_animation(false)
		CurrentGameState = GameState.BETTING
	if CurrentGameState == GameState.SHOP:
		reset_table()
		Signals.emit_signal("NextRound")
		CurrentGameState = GameState.BETTING
		return
	if CurrentGameState == GameState.BETTING:
		if Globals.coinsToThrow <= 0:
			CurrentGameState = GameState.SCORING
			Signals.emit_signal("ScoreCoins")
			ReDoCoinButton.disabled = true
			NextCoinButton.text = "---"
			
			return
		Signals.emit_signal("FlipCoin", false)
	if CurrentGameState == GameState.SCORING:
		_shop_animation(true)
		CurrentGameState = GameState.SHOP
		Signals.emit_signal("EnterShop")
		NextCoinButton.text = "Next Round"
	if CurrentGameState == GameState.GAME_OVER:
		reset_game()
		_title_animation(true)

func _shop_animation(slide_in : bool):
	if slide_in == true:
		_set_shop_visible(true)
		_generic_move_tween(ShopPanel,ShopAnchor.position)
	else:
		var tween = get_tree().create_tween().bind_node(self)
		tween.tween_property(ShopPanel, "position", Vector2(ShopAnchor.position.x+ShopPanel.size.x,0), 1).set_trans(Tween.TRANS_QUINT)
		tween.tween_callback(_set_shop_visible.bind(false))
		
func _set_shop_visible(envisible : bool): 
	if envisible : ShopPanel.visible = true
	else: ShopPanel.visible = false
	
func _title_animation(is_show : bool):
	if is_show == false: #hide
		var ensize = get_viewport_rect().size
		var top = ensize.y + TitleAnchor.position.y
		_generic_move_tween(Title,Vector2(TitleAnchor.position.x,-top))
		credits.hide()
	else: 
		_generic_move_tween(Title,TitleAnchor.position)
		credits.show()
		
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
	
func _on_re_do_coin_button_button_up() -> void:
	Signals.emit_signal("FlipCoin", true)
		
func _flip_coin(_is_reflip : bool):
	$Layoutbox/Bottom/Center/LargeCoinZone/CoinCount.text = str("Coins:\nx",Globals.coinsToThrow)
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

func pop_up_message(textToSay : String, pos : Vector2, move_to : Vector2, textColour : Color):
	var message = Label.new()
	message.text = textToSay
	message.position = Vector2(pos.x,pos.y)
	message.modulate = textColour
	message.add_theme_font_size_override("font_size", 34)
	add_child(message)
	var tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(message, "position", Vector2(move_to.x,move_to.y), 1).set_trans(tween.TRANS_QUAD)
	tween.tween_callback(message.queue_free)
	
func _item_speech_bubble(item_name : String, item_desc : String):
	$Layoutbox/Top/DealerZone/AdjacentUI/SpeechBubble/MarginContainer/Control/Label.add_theme_font_size_override("normal_font_size", 30)
	$Layoutbox/Top/DealerZone/AdjacentUI/SpeechBubble/MarginContainer/Control/Label.add_theme_font_size_override("bold_font_size", 30)
	var combined_str = str("[b]",item_name,"[/b]","\n",item_desc)
	_create_speech_bubble(combined_str)
	
	
func _create_speech_bubble(textToSay : String):
	SpeechBubble.show()
	var txt = $Layoutbox/Top/DealerZone/AdjacentUI/SpeechBubble/MarginContainer/Control/Label
	txt.text = textToSay
	
func _close_speech_bubble():
	$Layoutbox/Top/DealerZone/AdjacentUI/SpeechBubble/MarginContainer/Control/Label.add_theme_font_size_override("normal_font_size", 40)
	$Layoutbox/Top/DealerZone/AdjacentUI/SpeechBubble/MarginContainer/Control/Label.add_theme_font_size_override("bold_font_size", 40)
	SpeechBubble.hide()
	
func change_tie_button_down():
	currentColorTie += 1
	if currentColorTie >= 4: 
		currentColorTie = 0
	$Layoutbox/Top/DealerZone/DealerPuppet/ColorRect.color = colorPalette[currentColorTie]
	
func check_round_won():
	#contingency if the round is force ended
	if CurrentGameState == GameState.BETTING:
		CurrentGameState = GameState.SCORING
		ReDoCoinButton.disabled = true
		NextCoinButton.disabled = true
	#the regular scoring check resumes here
	if Globals.currentScore >= Globals.currentScoreRequirement:
		Signals.emit_signal("RoundWon")
		RoundNumber += 1
		_create_speech_bubble("Round Cleared!\nWell Done")
		NextCoinButton.text = "Shop"
	else: 
		print("Game Over!")
		game_over()
	if Globals.currentScore >= highest_score : highest_score = Globals.currentScore
	_update_score_requirement_ui()
	if CurrentGameState != GameState.GAME_OVER && RoundNumber == 9:
		game_won()
	NextCoinButton.disabled = false
	
func game_over():
	#$GameOverPanel.show()
	Signals.emit_signal("RoundLost")
	_create_speech_bubble("Game Over!~")
	CurrentGameState = GameState.GAME_OVER
	NextCoinButton.text = "Play Again?"
	
func game_won():
	$GameWonPanel.show()
	_create_speech_bubble("You Win!!")
	CurrentGameState = GameState.GAME_OVER
	Signals.emit_signal("GameWon")
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
	Globals.maxPurchases = 2
	await get_tree().create_timer(0.01).timeout #this is so dumb but if you don't stall it slightly both loops happen concurrently and it screws them up
	for i in 4:
		Signals.emit_signal("PurchaseCoin")
	$GameOverPanel.hide()
	$GameWonPanel.hide()
	highest_score = 0
	reset_table()
	
func reset_table():
	Signals.emit_signal("ResetTable")
	Globals.currentScore = 0
	Globals.CoinHistory.clear()
	Globals.coinCount = 0
	Globals.coinsToThrow = Globals.maxCoinCount
	reflipCount = maxReflipCount
	CurrentRoundLabel.text = str("Round ",RoundNumber,"/8")
	Globals.currentScoreRequirement = RequiredScore[RoundNumber-1]
	_update_score_requirement_ui()
	ReflipAmmount.text = str(reflipCount,"x")
	ReDoCoinButton.disabled = true
	CoinAmmount.text = str(Globals.coinCount,"/",Globals.maxCoinCount)
	NextCoinButton.text = "Flip"
	_shop_animation(false)
	CurrentGameState = GameState.MENU

func _on_item_compendium_button_toggled(toggled_on: bool) -> void:
	$ItemCompendium.visible = toggled_on
	$HelpButton.disabled = toggled_on

func _on_help_button_toggled(toggled_on: bool) -> void:
	$HowToPlay.visible = toggled_on
	$ItemCompendiumButton.disabled = toggled_on
