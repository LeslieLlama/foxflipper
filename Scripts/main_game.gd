extends Control

var rng = RandomNumberGenerator.new()
var coinCount = 0
var reflipCount = 3

var CoinHistory = []
var CoinHistorySprites = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HeadsCoinSprite.hide()
	$TailsCoinSprite.hide()
	CoinHistorySprites = [$CoinFlipHistory/ColorRect, $CoinFlipHistory/ColorRect2, $CoinFlipHistory/ColorRect3, $CoinFlipHistory/ColorRect4, $CoinFlipHistory/ColorRect5, $CoinFlipHistory/ColorRect6]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_next_coin_button_button_up() -> void:
	if coinCount == 6:
		reset_table()
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
			CoinHistorySprites[coinCount].color = Color("D06559")
			reflipCount -= 1
		else:
			CoinHistory.append(1)
			CoinHistorySprites[coinCount].color = Color("D06559")
			coinCount += 1
		
	else: 
		$HeadsCoinSprite.hide()
		$TailsCoinSprite.show()
		if is_reflip == true && reflipCount > 0:
			CoinHistory.pop_back()
			CoinHistory.append(0)
			CoinHistorySprites[coinCount].color = Color("65A7C1")
			reflipCount -= 1
		else:
			CoinHistory.append(0)
			CoinHistorySprites[coinCount].color = Color("65A7C1")
			coinCount += 1
	$ReDoCoinButton/ReflipAmmount.text = str(reflipCount,"x")
	$NextCoinButton/CoinAmmount.text = str(coinCount,"/6")
	
func reset_table():
	CoinHistory.clear()
	for c in CoinHistorySprites:
		c.color = Color.WHITE
	coinCount = 0
	reflipCount = 3
	$ReDoCoinButton/ReflipAmmount.text = str(reflipCount,"x")
	$NextCoinButton/CoinAmmount.text = str(coinCount,"/6")
