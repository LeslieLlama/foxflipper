extends Node

var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.CoinScored.connect(PlayCoinTriggerSound)
	Signals.CoinHistoryDisplayUpdate.connect(PlayCoinFlipSound)
	Signals.NextRound.connect(AddBackgroundMusicPitch)
	Signals.AllCoinsScored.connect(MinusBackgroundMusicPitch)
	Signals.ComboScored.connect(PlayCoinComboSound)
	Signals.AddPointsToCoin.connect(PlayAddPointsSound)
	AddBackgroundMusicPitch()
	$BackgroundMusic.play()


func PlayCoinTriggerSound():
	var pitchRandomisation = rng.randf_range(1, 1.5)
	$CoinScoringSound.pitch_scale = pitchRandomisation
	$CoinScoringSound.play()
func PlayCoinComboSound():
	var pitchRandomisation = rng.randf_range(1, 1.5)
	$CoinComboSound.pitch_scale = pitchRandomisation
	$CoinComboSound.play()
func PlayCoinFlipSound():
	var pitchRandomisation = rng.randf_range(1, 2)
	$CoinLandingSound.pitch_scale = pitchRandomisation
	$CoinLandingSound.play()
func PlayAddPointsSound():
	var pitchRandomisation = rng.randf_range(1, 2)
	$CoinAddPointsSound.pitch_scale = pitchRandomisation
	$CoinAddPointsSound.play()
func AddBackgroundMusicPitch():
	$BackgroundMusic.pitch_scale += 0.05
func MinusBackgroundMusicPitch():
	$BackgroundMusic.pitch_scale -= 0.05
