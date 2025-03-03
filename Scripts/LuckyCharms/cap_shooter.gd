extends LuckyCharm

var rng = RandomNumberGenerator.new()
func ImmediateEffect():
	if Globals.CoinHistory.size() % 6 == 0:
		await get_tree().create_timer(0.2).timeout
		_activation_animation()
		PlayCoinTriggerSound()
		print("Six Shooter Activation")
		Globals.currentScoreRequirement /=2 
		Signals.emit_signal("UpdateScoreUI")
		
func _activation_animation():
	if tween:
		tween.kill()
	tween = get_tree().create_tween().set_parallel(true).bind_node(self)
	tween.tween_property($TextureRect, "rotation_degrees", 20, 0.1).set_trans(Tween.TRANS_SPRING)
	tween.tween_property($TextureRect, "scale", Vector2(1.3,1.3), 0.1).set_trans(Tween.TRANS_SINE)
	tween.chain().tween_property($TextureRect, "rotation_degrees", 0, 0.1).set_trans(Tween.TRANS_SPRING)
	tween.tween_property($TextureRect, "scale", Vector2(1,1), 0.1).set_trans(Tween.TRANS_SINE)
	
func PlayCoinTriggerSound():
	var pitchRandomisation = rng.randf_range(1, 1.5)
	$PistolFireSound.pitch_scale = pitchRandomisation
	$PistolFireSound.play()
