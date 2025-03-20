extends LuckyCharm

var pinballPoints = 0

func _ready() -> void:
	assign_seq_sym()
	Signals.ScoreCoins.connect(_scoring_begins)
	Signals.AllCoinsScored.connect(_scoring_ends)

func ImmediateEffect():
	await get_tree().create_timer(0.2).timeout
	_activation_animation()
	Globals.currentScore += pinballPoints
	print("Pinball Activation")
	Signals.emit_signal("UpdateScoreUI")
	
func _scoring_begins():
	scoring_is_ongoing = true
	var index = await find_number_of_ocurrances("0011",Globals.CoinHistory)
	print(str("number of occurances = ", index))
	
func find_number_of_ocurrances(pattern : String, sequence = []):
	var occurances = 0
	var index = 0
	var prev_index = 0
	var sequenceString = ""
	for c in sequence:
		sequenceString = str(sequenceString,c)
	await get_tree().create_timer(0.1).timeout
	for c in sequence.size():
		index = sequenceString.find(pattern,prev_index)
		print(prev_index)
		if index == -1:
			return occurances
		else: 
			occurances += 1
			prev_index = index+1
	return occurances
	
	
	
