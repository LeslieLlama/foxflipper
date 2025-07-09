extends TextureRect

@export var BettingSprite : Texture2D
@export var ScoringSprite : Texture2D
@export var ShoppingSprite : Texture2D
@export var RoundWonSprite : Texture2D
@export var RoundLostSprite : Texture2D
@export var GameWonSprite : Texture2D

@export var current_position : Vector2

func _ready() -> void:
	texture = BettingSprite
	Signals.ScoreCoins.connect(scoring_begin)
	Signals.NextRound.connect(betting_begin)
	Signals.ResetGame.connect(betting_begin)
	Signals.EnterShop.connect(enter_shop)
	Signals.RoundWon.connect(round_won)
	Signals.RoundLost.connect(round_lost)
	Signals.GameWon.connect(game_won)
	get_tree().get_root().size_changed.connect(on_resize)
	await get_tree().create_timer(0.01).timeout
	current_position = position
	
	
#the godot signal on screen resize is too slow? or at least updates inconsistently enough that there can be a difference between the screen resize and the actual positon recording
#so a timer function that delays the call until the window has stopped resizing, and records the position of the dealer 0.4 seconds after the fact makes capturing the current position for tweening purposes more accurate
#0.4 might be a bit long but it seems to work consistently..?
func on_resize():
	$Timer.start()
	if $Timer.time_left > 0:
		return
	
func _on_timer_timeout() -> void:
	print("resizing...")
	current_position = position
	
func betting_begin():
	_switch_sprite(0)
	
func scoring_begin():
	_switch_sprite(1)
	
func enter_shop():
	_switch_sprite(2)

func round_won():
	_switch_sprite(3)
	
func round_lost():
	_switch_sprite(4)
	
func game_won():
	_switch_sprite(5)
	
func _switch_sprite(spr : int):
	match spr:
		0: 
			texture = BettingSprite
		1: 
			texture = ScoringSprite
		2: 
			texture = ShoppingSprite
		3:
			texture = RoundWonSprite
		4:
			texture = RoundLostSprite
		5:
			texture = GameWonSprite
		_:
			texture = BettingSprite
			print("ERROR : SWITCH SPRITE CALLED WITH INVALID INT")
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self, "position:y", current_position.y-8, 0.1).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "scale", Vector2(1,1.05), 0.1).set_trans(Tween.TRANS_SINE)
	tween.chain().tween_property(self, "position:y", current_position.y, 0.1).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "scale", Vector2(1,1), 0.1).set_trans(Tween.TRANS_SINE)
