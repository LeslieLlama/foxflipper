extends LuckyCharm


func _ready() -> void:
	assign_seq_sym()


func MultiplyScore():
	if Globals.itemNum == 1:
		await get_tree().create_timer(0.2).timeout
		print("paper crown trigger!")
		Globals.currentScore *= 3
		_activation_animation()

func _activation_animation():
	if tween:
		tween.kill()
	tween = get_tree().create_tween().set_parallel(true).bind_node(self)
	tween.tween_property($TextureRect, "rotation_degrees", -20, 0.2).set_trans(Tween.TRANS_SPRING)
	tween.tween_property($TextureRect, "scale", Vector2(1.3,1.3), 0.2).set_trans(Tween.TRANS_SINE)
	tween.chain().tween_property($TextureRect, "rotation_degrees", 0, 0.2).set_trans(Tween.TRANS_SPRING)
	tween.tween_property($TextureRect, "scale", Vector2(1,1), 0.2).set_trans(Tween.TRANS_SINE)
	
