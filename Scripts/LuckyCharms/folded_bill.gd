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
		Globals.maxPurchases -= 1
		Signals.emit_signal("RemoveItem", self)
		Signals.emit_signal("AddItemPurchaseSlot", false) 
		queue_free()
	
func item_enabled(val : bool):
	is_enabled = val
	Globals.maxPurchases += 1
	Signals.emit_signal("AddItemPurchaseSlot", true) 
