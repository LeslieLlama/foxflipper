extends Control

var rng = RandomNumberGenerator.new()
var coinCount = 0
var reflipCount = 3

var headsValue = 50
var tailsValue = 50
var currentScore = 0

var CoinHistory = []
var CoinHistorySprites = []
var scoreDisplayed : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HeadsCoinSprite.hide()
	$TailsCoinSprite.hide()
	CoinHistorySprites = [$CoinFlipHistory/ColorRect, $CoinFlipHistory/ColorRect2, $CoinFlipHistory/ColorRect3, $CoinFlipHistory/ColorRect4, $CoinFlipHistory/ColorRect5, $CoinFlipHistory/ColorRect6]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_next_coin_button_button_up() -> void:
	if scoreDisplayed == true:
		reset_table()
		return
	if coinCount == 6:
		display_score()
		scoreDisplayed = true
		$ReDoCoinButton.disabled = true	
		$NextCoinButton.text = "Next Round"
	else:
		flip_coin(false)
	
func _on_re_do_coin_button_button_up() -> void:
	flip_coin(true)
	
func flip_coin(is_reflip : bool):
	var flip_value = rng.randi_range(0, 1)
	if flip_value == 1:
		$HeadsCoinSprite.show()
		$TailsCoinSprite.hide()
		if is_reflip == true && reflipCount > 0:
			CoinHistory.pop_back()
			CoinHistory.append(1)
			reflipCount -= 1
		else:
			CoinHistory.append(1)
			coinCount += 1
	else: 
		$HeadsCoinSprite.hide()
		$TailsCoinSprite.show()
		if is_reflip == true && reflipCount > 0:
			CoinHistory.pop_back()
			CoinHistory.append(0)
			reflipCount -= 1
		else:
			CoinHistory.append(0)
			coinCount += 1
	$ReDoCoinButton/ReflipAmmount.text = str(reflipCount,"x")
	$NextCoinButton/CoinAmmount.text = str(coinCount,"/6")
	print(CoinHistory)
	coin_history_display_update()
	if coinCount == 6: $NextCoinButton.text = "Score Coins"
	

func coin_history_display_update():
	for c in CoinHistory:
		if c == 1:
			CoinHistorySprites[coinCount-1].color = Color("D06559")
		else:
			CoinHistorySprites[coinCount-1].color = Color("65A7C1")
			
func coin_pattern_searcher():
	var runCount = 1
	var previousCoinValue = -1
	var highestRunCount = 1
	for c in CoinHistory:
		if c == 0:
			currentScore += tailsValue
		else: 
			currentScore += headsValue
		if c == previousCoinValue:
			runCount += 1
		else: 
			runCount = 1
		previousCoinValue = c
		if runCount >= 3:
			highestRunCount = runCount
	currentScore *= highestRunCount
	
		
func display_score():
	coin_pattern_searcher()
	$RoundScoreLabel.text = str(currentScore)
	$ShopPanel.show()
func reset_table():
	currentScore = 0
	CoinHistory.clear()
	for c in CoinHistorySprites:
		c.color = Color.WHITE
	coinCount = 0
	reflipCount = 3
	scoreDisplayed = false
	$ReDoCoinButton/ReflipAmmount.text = str(reflipCount,"x")
	$NextCoinButton/CoinAmmount.text = str(coinCount,"/6")
	$NextCoinButton.text = "Flip"
	$ReDoCoinButton.disabled = false
	$ShopPanel.hide()
