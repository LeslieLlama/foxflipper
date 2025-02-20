extends LuckyCharm


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
		Signals.emit_signal("HoldingTrainStub", false)
		queue_free()
	
func item_enabled(val : bool):
	is_enabled = val
	Signals.emit_signal("HoldingTrainStub", true)
