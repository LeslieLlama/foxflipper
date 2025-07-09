extends LuckyCharm

var pinballPoints = 0
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	assign_seq_sym()
	Signals.ScoreCoins.connect(_scoring_begins)
	Signals.AllCoinsScored.connect(_scoring_ends)
	

func MultiplyScore():
	if is_enabled == false or pinballPoints <= 0:
		return
	await get_tree().create_timer(0.2).timeout
	_activation_animation()
	PlayAddPointsToScoreSound()
	var pos = Vector2(-Globals.score_position.x, (Globals.score_position.y))
	var new_pos = Vector2(pos.x, pos.y-30)
	Signals.emit_signal("PopupMessage", str("+",pinballPoints),pos,new_pos,colorRed)
	Globals.currentScore += pinballPoints
	print("Pinball Activation")
	Signals.emit_signal("UpdateScoreUI")
	
func _scoring_begins():
	if is_enabled == false:
		return
	scoring_is_ongoing = true
	var index = await find_number_of_ocurrances("000111",Globals.CoinHistory)
	var xdex = await find_number_of_ocurrances("111000",Globals.CoinHistory)
	var pointsToAdd = 0
	index += xdex
	for i in index:
		pointsToAdd += 1000
	if pointsToAdd <= 0:
		return
	pinballPoints += pointsToAdd
	_add_points_to_self_animation()
	PlayAddPointsToSelfSound()
	var pos = self.global_position
	var new_pos = Vector2(pos.x, pos.y-30)
	Signals.emit_signal("PopupMessage", str("+",pointsToAdd),pos,new_pos,colorRed)
	UpdateDescription()
	
func find_number_of_ocurrances(pattern : String, sequence = []):
	var occurances = 0
	var index = 0
	var prev_index = 0
	var sequenceString = ""
	for c in sequence:
		sequenceString = str(sequenceString,c)
	await get_tree().create_timer(0.01).timeout
	for c in sequence.size():
		index = sequenceString.find(pattern,prev_index)
		print(prev_index)
		if index == -1:
			return occurances
		else: 
			occurances += 1
			prev_index = index+1
	return occurances
	
func UpdateDescription():
	Description = str("+",pinballPoints," Points\nCreate this chain : HHH/TTT, TTT/HHH to add +1000 points to this charm")
	
func PlayAddPointsToSelfSound():
	var pitchRandomisation = rng.randf_range(1, 1.5)
	$AddPointsToSelfSound.pitch_scale = pitchRandomisation
	$AddPointsToSelfSound.play()
func PlayAddPointsToScoreSound():
	var pitchRandomisation = rng.randf_range(1, 1.5)
	$AddPointsToScoreSound.pitch_scale = pitchRandomisation
	$AddPointsToScoreSound.play()
	
func _add_points_to_self_animation():
	var pos = $TextureRect.position
	var new_pos = Vector2(pos.x, pos.y-20)
	if tween:
		tween.kill()
	tween = get_tree().create_tween().bind_node(self)
	tween.tween_property($TextureRect, "position:y", new_pos.y, 0.2).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property($TextureRect, "position:y", pos.y, 0.2).set_trans(Tween.TRANS_SINE)
	
	
	
