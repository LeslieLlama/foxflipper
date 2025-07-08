extends GridContainer

@export var coin_marker : PackedScene 

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
	Signals.FlipCoin.connect(reflip_used)
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
		if c == 0:
			Globals.CoinHistorySprites[Globals.coinCount-1].texture = tailsCoinSprite
		#if Globals.coinsToThrow + Globals.coinCount != Globals.maxCoinCount:
			#Globals.CoinHistorySprites[Globals.coinsToThrow + Globals.coinCount].texture = canceledCoinSprite
	print(Globals.CoinValues)
	mini_coin_trigger_animation(Globals.coinCount-1)
	
func reflip_used(is_reflip : bool):
	if is_reflip == true:
		#this check is spesifically for reflipping items, they alter the number of remaining coins to act as "free" reflips and this causes a descrepancy with the number of flipped coins no longer aligning to the number of actual coins in the array
		#to counter this, the below line checks for the descrepancy (ie using an reflipping item) and returns before the sprite updat code can run. 
		if (Globals.coinsToThrow + Globals.coinCount)-1 >= Globals.CoinHistorySprites.size():
			return
		Globals.CoinHistorySprites[(Globals.coinsToThrow + Globals.coinCount)-1].texture = canceledCoinSprite

func mini_coin_trigger_animation(c : int):
	var tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(Globals.CoinHistorySprites[c], "scale", Vector2(1.1,1.1), 0.1).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(Globals.CoinHistorySprites[c], "scale", Vector2(1,1), 0.1).set_trans(Tween.TRANS_BOUNCE)
	
	
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
	#var child_node = TextureRect.new()
	var child_node = coin_marker.instantiate()
	child_node.texture = emptyCoinSprite
	child_node.custom_minimum_size = Vector2(75,75)
	child_node.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	child_node.stretch_mode = TextureRect.STRETCH_SCALE
	child_node.Assign_number(Globals.maxCoinCount)
	#child_node.connect("mouse_entered",_coin_tooltip)
	#child_node.mouse_entered.connect(_coin_tooltip.bind(child_node))
	#player.hit.connect(_on_player_hit.bind("sword", 100))

	self.add_child(child_node)
	Globals.CoinHistorySprites = self.get_children()
	mini_coin_trigger_animation(Globals.maxCoinCount-1)
	
func _coin_tooltip(tex : Texture):
	var x = Globals.CoinHistorySprites.find(tex)
	print(str("coin is : ", x))
	
