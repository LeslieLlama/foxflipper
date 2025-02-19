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
	if Globals.CoinValues.size() < numInSequence-1:
		return "Busted Coin"
	if Globals.CoinHistory[numInSequence-1] == 1:
		return "Heads"
	else:
		return "Tails"
	
func coinValue():
	if Globals.CoinValues.is_empty() == true:
		return "Not Yet Scored"
	elif numInSequence-1 > Globals.CoinValues.size():
		return str("A reflip has been used, reducing the maxiumum coin count")
	else: 
		return str("Value : ",Globals.CoinValues[numInSequence-1])
