extends TextureRect

var numInSequence
func Assign_number(i : int):
	numInSequence = i

func _on_mouse_entered() -> void:
	Signals.emit_signal("Mouse_Over", coinSide(), coinValue())

func _on_mouse_exited() -> void:
	Signals.emit_signal("Mouse_End")
	
func coinSide():
	if Globals.coinsToThrow + Globals.coinCount < numInSequence:
		return "Busted Coin"
	elif Globals.CoinHistory.size() < numInSequence:
		return "Empty Coin Slot"	
	elif Globals.CoinHistory[numInSequence-1] == 1:
		return "Heads"
	elif Globals.CoinHistory[numInSequence-1] == 0:
		return "Tails"
	else:
		return "calc error"
	
	
func coinValue():
	if Globals.CoinValues.is_empty():
		return "Not Yet Scored"
	if Globals.coinsToThrow + Globals.coinCount < numInSequence:
		return str("A reflip has been used, reducing the maxiumum coin count")
	elif Globals.CoinHistory.size() < numInSequence:
		return "Not Yet Scored"
	else: 
		return str("Value : ",Globals.CoinValues[numInSequence-1])
