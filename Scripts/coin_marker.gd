extends TextureRect

var numInSequence
func Assign_number(i : int):
	numInSequence = i

func _on_mouse_entered() -> void:
	Signals.emit_signal("Mouse_Over", coinSide(), coinValue())

func _on_mouse_exited() -> void:
	Signals.emit_signal("Mouse_End")
	
func coinSide():
	if Globals.CoinHistory.size() <= numInSequence-1:
		return "Empty Coin Slot"
	if Globals.CoinHistory[numInSequence-1] == 1:
		return "Heads"
	else:
		return "Tails"
	
func coinValue():
	if Globals.CoinValues.is_empty() == true:
		return "Not Yet Scored"
	else: 
		return str("Value : ",Globals.CoinValues[numInSequence-1])
