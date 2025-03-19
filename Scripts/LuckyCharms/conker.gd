extends LuckyCharm

var rng = RandomNumberGenerator.new()
var ConkerPoints = 20
var breakChance = 0.05

func _ready() -> void:
	assign_seq_sym()
	Signals.ScoreCoins.connect(_scoring_begins)
	Signals.AllCoinsScored.connect(_scoring_ends)
	Signals.SwapItems.connect(_items_swapped)

func ImmediateEffect():
	await get_tree().create_timer(0.2).timeout
	_activation_animation()
	PlayCoinTriggerSound()
	Globals.currentScore += ConkerPoints
	print("Conker Activation")
	Signals.emit_signal("UpdateScoreUI")
	
		
func _items_swapped():
	if is_enabled == false: 
		return
	var breakTest = rng.randf_range(0, 1)
	if breakTest < breakChance:
		BreakConker()
	ConkerPoints += 30
	breakChance += 0.02
	Description = str("+",ConkerPoints," points\n",int(breakChance*100),"% chance of breaking when swapped.\nSwap charm positions to add +30 points to this charm, and +2% chance of breaking")
	
func PlayCoinTriggerSound():
	var pitchRandomisation = rng.randf_range(1, 1.5)
	$ConkerCrackSound.pitch_scale = pitchRandomisation
	$ConkerCrackSound.play()
	
func BreakConker():
	Signals.emit_signal("RemoveItem", self)
	queue_free()
