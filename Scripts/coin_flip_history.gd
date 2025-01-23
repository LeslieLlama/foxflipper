extends GridContainer

@export var emptyCoinSprite : Texture2D
@export var headsCoinSprite : Texture2D
@export var tailsCoinSprite : Texture2D

var CoinHistorySprites = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.CoinHistoryDisplayUpdate.connect(coin_history_display_update)
	Signals.MiniCoinTriggerAnimation.connect(mini_coin_trigger_animation)
	Signals.PurchaseCoin.connect(_add_coin)
	Signals.ResetGame.connect(_reset_game)
	Signals.ResetTable.connect(_reset_table)


func coin_history_display_update():
	for c in Globals.CoinHistory:
		if c == 1:
			CoinHistorySprites[Globals.coinCount-1].texture = headsCoinSprite
		else:
			CoinHistorySprites[Globals.coinCount-1].texture = tailsCoinSprite
	mini_coin_trigger_animation(Globals.coinCount)

func mini_coin_trigger_animation(c : int):
	var tween = get_tree().create_tween().bind_node(self)
	tween.tween_property(CoinHistorySprites[c], "scale", Vector2(1.1,1.1), 0.1).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(CoinHistorySprites[c], "scale", Vector2(1,1), 0.1).set_trans(Tween.TRANS_BOUNCE)
	
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
