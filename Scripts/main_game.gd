extends Control

var rng = RandomNumberGenerator.new()
var coinCount = 0
var maxCoinCount = 0
var reflipCount = 3

var totalValue = 100
var headsValue = 50
var tailsValue = 50
var currentScore = 0

var RoundNumber = 1
var RequiredScore = [150,300,600,1200,1210,1220,1230,1240]

var CoinHistory = []
var CoinHistorySprites = []
var scoreDisplayed : bool = false

var purchases = 0

@onready var CoinHistoryNode = $CoinFlipHistory
@onready var NextCoinButton = $NextCoinButton
@onready var ReDoCoinButton = $ReDoCoinButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HeadsCoinSprite.hide()
	$TailsCoinSprite.hide()
	for i in 3:
		_add_coin()
	#CoinHistorySprites = CoinHistoryNode.get_children()
	

func _on_next_coin_button_button_up() -> void:
	if scoreDisplayed == true:
		reset_table()
		return
	if coinCount == maxCoinCount:
		display_score()
		scoreDisplayed = true
		ReDoCoinButton.disabled = true	
		NextCoinButton.text = "Next Round"
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
	$NextCoinButton/CoinAmmount.text = str(coinCount,"/",maxCoinCount)
	print(CoinHistory)
	coin_history_display_update()
	if coinCount == maxCoinCount: $NextCoinButton.text = "Score Coins"
	if coinCount > 0:
		$CoinBetting/AddTails.disabled = true
		$CoinBetting/AddHeads.disabled = true

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
	if currentScore >= RequiredScore[RoundNumber-1]:
		RoundNumber += 1
		$ShopPanel.show()
	else: 
		print("Game Over!")
		game_over()
	$RoundScoreLabel.text = str(currentScore)
	
	
func game_over():
	
	$GameOverPanel.show()
	
func _on_retry_button_button_up() -> void:
	reset_game()
	
func reset_game():
	reset_table()
	RoundNumber = 1
	maxCoinCount = 0
	CoinHistorySprites.clear()
	for c in CoinHistoryNode.get_children():
		c.queue_free()
	await get_tree().create_timer(0.01).timeout #this is so dumb but if you don't stall it slightly both loops happen concurrently and it screws them up
	for i in 3:
		_add_coin()
	totalValue = 100
	$GameOverPanel.hide()



func reset_table():
	currentScore = 0
	CoinHistory.clear()
	for c in CoinHistorySprites:
		c.color = Color.WHITE
	coinCount = 0
	reflipCount = 3
	scoreDisplayed = false
	headsValue = totalValue%2
	tailsValue = totalValue - headsValue
	$CurrentRoundLabel.text = str("Round","\n",RoundNumber,"/12")
	$RequiredScoreLabel.text = str(RequiredScore[RoundNumber-1])
	$RoundScoreLabel.text = str(currentScore)
	$ReDoCoinButton/ReflipAmmount.text = str(reflipCount,"x")
	$NextCoinButton/CoinAmmount.text = str(coinCount,"/",maxCoinCount)
	$NextCoinButton.text = "Flip"
	
	ReDoCoinButton.disabled = false
	$CoinBetting/AddTails.disabled = false
	$CoinBetting/AddHeads.disabled = false
	$ShopPanel.hide()
	

func _on_add_tails_button_up() -> void:
	$CoinBetting/AddHeads.disabled = false
	tailsValue += 10
	headsValue -= 10
	if tailsValue >= totalValue:
		$CoinBetting/AddTails.disabled = true
	else: $CoinBetting/AddTails.disabled = false
	$CoinBetting/SplitPoints.text = str(headsValue,"/",tailsValue)

func _on_add_heads_button_up() -> void:
	$CoinBetting/AddTails.disabled = false
	tailsValue -= 10
	headsValue += 10
	if headsValue >= totalValue:
		$CoinBetting/AddHeads.disabled = true
	else: $CoinBetting/AddHeads.disabled = false
	$CoinBetting/SplitPoints.text = str(headsValue,"/",tailsValue)
	
func _add_coin():
	maxCoinCount += 1
	var child_node = ColorRect.new()
	child_node.custom_minimum_size = Vector2(50,50)
	CoinHistoryNode.add_child(child_node)
	CoinHistorySprites = CoinHistoryNode.get_children()


func _add_points():
	totalValue += 50 

func add_purchase():
	purchases += 1
