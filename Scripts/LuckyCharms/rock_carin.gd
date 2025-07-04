extends LuckyCharm

var rng = RandomNumberGenerator.new()
@export var charm_value = 300


func _ready() -> void:
	assign_seq_sym()
	Signals.RemoveItem.connect(add_points_to_self)
	Signals.ResetGame.connect(_reset_game)

func ImmediateEffect():
	await get_tree().create_timer(0.2).timeout
	_activation_animation()
	PlayCoinTriggerSound()
	Globals.currentScore += charm_value
	Signals.emit_signal("UpdateScoreUI")
	print("Rock Carin Activation")
	
	
func _process(_delta: float) -> void:
	if is_enabled == false: 
		return
	if mouseHold == true:
		destructionProgress += 1
	else:
		destructionProgress = 0
	$TextureProgressBar.value = destructionProgress
	if destructionProgress >= $TextureProgressBar.max_value:
		Signals.emit_signal("RemoveItem", self)
		queue_free()
		
func add_points_to_self(item : Control):
	if item.get_script() == self.get_script():
		charm_value += 300
		rarity = 10
	Description = str(
		"+",charm_value," Points\nChuck this item to add +300 value to above (more common once bought)"
	)
	
func PlayCoinTriggerSound():
	var pitchRandomisation = rng.randf_range(1, 1.5)
	$RockActivationSound.pitch_scale = pitchRandomisation
	$RockActivationSound.play()
	
func _reset_game():
	charm_value = 300
	rarity = 1
	Description = str(
		"+",charm_value," Points\nChuck this item to add +300 value to above (more common once bought)"
	)
	
